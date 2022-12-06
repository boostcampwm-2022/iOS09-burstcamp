//
//  CacheManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/27.
//

import Combine
import UIKit
import ImageIO

final class ImageCacheManager: NSObject, NSCacheDelegate {

    private static let countLimit = 100
    private static let totalCostLimit = 1024 * 1024 * ImageCacheManager.countLimit
    private static let thumnailMaxPixel = 300

    static let shared = ImageCacheManager(
        countLimit: ImageCacheManager.countLimit,
        totalCostLimit: ImageCacheManager.totalCostLimit
    )
    private var cache = NSCache<NSString, UIImage>()
    var cancelBag = Set<AnyCancellable>()

    private init(
        countLimit: Int,
        totalCostLimit: Int
    ) {
        super.init()
        cache.delegate = self
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
//        guard let image = obj as? UIImage else { return }
//        print("\(image)삭제중...\n", obj)
    }

    func image(
        urlString: String,
        isDiskCaching: Bool
    ) -> AnyPublisher<UIImage?, Never> {
        // 1. memory cache
        if let image = memoryCachedImage(urlString: urlString) {
            let etag = UserDefaultsManager.etag(urlString: urlString)
            return request(urlString: urlString, etag: etag, isDisk: isDiskCaching)
                .catch { _ in Just(image) }
                .eraseToAnyPublisher()
        }

        // 2. disk cache
        if isDiskCaching, let image = diskCachedImage(urlString: urlString) {
            let etag = UserDefaultsManager.etag(urlString: urlString)
            return request(urlString: urlString, etag: etag, isDisk: isDiskCaching)
                .catch { _ in Just(image) }
                .eraseToAnyPublisher()
        }

        // 3. network request
        return request(urlString: urlString, etag: nil, isDisk: isDiskCaching)
            .catch { _ in
                Just(nil)
            }
            .eraseToAnyPublisher()
    }

    // MARK: Memory

    private func saveInMemory(image: UIImage, urlString: String) {
        let key = NSString(string: urlString)
        ImageCacheManager.shared.cache.setObject(image, forKey: key)
    }

    private func memoryCachedImage(urlString: String) -> UIImage? {
        let key = NSString(string: urlString)
        if let cachedImage = ImageCacheManager.shared.cache.object(forKey: key) {
            return cachedImage
        }
        return nil
    }

    // MARK: Disk

    private func saveInDisk(image: UIImage, urlString: String) {
        let fileManager = FileManager.default
        let filePath = filePath(with: urlString)

        fileManager.createFile(
            atPath: filePath.path,
            contents: image.jpegData(compressionQuality: 0.4)
        )
    }

    private func diskCachedImage(urlString: String) -> UIImage? {
        let fileManager = FileManager.default
        let filePath = filePath(with: urlString)

        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath),
                  let image = UIImage(data: imageData)
            else { return nil }
            return image
        }

        return nil
    }

    // MARK: Network request with Etag

    private func request(urlString: String, etag: String?, isDisk: Bool)
    -> AnyPublisher<UIImage?, ImageCacheError> {
        guard let url = URL(string: urlString)
        else { return Fail(error: ImageCacheError.invalidationImageURL).eraseToAnyPublisher() }

        var request = URLRequest(url: url)
        request.addValue(etag ?? "", forHTTPHeaderField: "If-None-Match")

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response -> UIImage? in
                guard let self = self else { return nil }
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        self.saveEtag(by: response, url: url)
                    case 304:
                        throw ImageCacheError.notModifiedImage
                    default:
                        throw self.makeImageCacheError(by: response.statusCode)
                    }
                }
//                print(data)
                return self.createThumnail(data: data)
            }
            .map { image in
                self.saveInMemoryAndDisk(image: image, urlString: urlString, isDisk: isDisk)
                return image
            }
            .mapError(makeImageCacheError(by:))
            .eraseToAnyPublisher()
    }

    private func saveInMemoryAndDisk(image: UIImage?, urlString: String, isDisk: Bool) {
        guard let image = image else { return }
        saveInMemory(image: image, urlString: urlString)
        if isDisk {
            saveInDisk(image: image, urlString: urlString)
        }
    }

    private func saveEtag(by response: HTTPURLResponse, url: URL) {
        let etag = response.allHeaderFields["Etag"] as? String ?? ""
        let key = url.absoluteString
        UserDefaultsManager.save(etag: etag, urlString: key)
    }

    private func makeImageCacheError(by statusCode: Int) -> ImageCacheError {
        return ImageCacheError.network(error: NetworkError(rawValue: statusCode)
                                       ?? NetworkError.unknownError
        )
    }

    private func makeImageCacheError(by error: Error) -> ImageCacheError {
        guard let error = error as? ImageCacheError
        else { return ImageCacheError.unknownerror }
        return error
    }

    private func filePath(with urlString: String) -> URL {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let imagePath = urlString.replacingOccurrences(of: "/", with: "-")
        return cacheURL.appendingPathExtension(imagePath)
    }

    private func createThumnail(data: Data) -> UIImage {
        guard let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(
                cgImageSource, 0, nil
              ) as? [CFString: Any],
              let imageWidth = properties[kCGImagePropertyPixelWidth] as? UInt,
              let imageHeight = properties[kCGImagePropertyPixelHeight] as? UInt
        else { return UIImage() }

//        print(imageWidth, imageHeight)
        let imageMaxPixel = maxPixel(width: imageWidth, height: imageHeight)

        let thumnailOptions = [
            kCGImageSourceShouldCache: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: imageMaxPixel,
            kCGImageSourceCreateThumbnailWithTransform: true
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(cgImageSource, 0, thumnailOptions)
        else { return UIImage() }

        return UIImage(cgImage: cgImage)
    }

    private func maxPixel(width: UInt, height: UInt) -> Int {
        let max = Int(max(width, height))
//        print("최대픽셀", maxPixel)
        switch max {
        case 0...300: return max
        case 301...600: return ImageCacheManager.thumnailMaxPixel
        default: return max / 2
        }
    }
}
