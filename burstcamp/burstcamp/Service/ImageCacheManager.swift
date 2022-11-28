//
//  CacheManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/27.
//

import Combine
import UIKit

final class ImageCacheManager {

    static let shared = ImageCacheManager()
    private var cache = NSCache<NSString, UIImage>()
    var cancelBag = Set<AnyCancellable>()

    private init() {}

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
                Just(UIImage(systemName: "figure.play")!)
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
            .tryMap { data, response -> UIImage? in
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
                return UIImage(data: data)
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
}
