//
//  SignUpViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import Foundation

final class SignUpBlogViewModel {

    private let signUpUseCase: SignUpUseCase
    private let bcFireStoreService = BCFirestoreService()

    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }

    struct Input {
        let blogAddressTextFieldDidEdit: AnyPublisher<String, Never>
        let nextButtonDidTap: PassthroughSubject<Void, Never>
        let skipConfirmDidTap: PassthroughSubject<Void, Never>
        let blogTitleConfirmDidTap: PassthroughSubject<String, Never>
        let saveFCMToken: PassthroughSubject<Void, Never>
    }

    struct Output {
        let validateBlogAddress: AnyPublisher<Bool, Never>
        let signUpWithNextButton: AnyPublisher<String, Never>
        let signUpWithBlogTitle: AnyPublisher<User, Error>
        let signUpWithSkipButton: AnyPublisher<User, Error>
    }

    private var cancelBag = Set<AnyCancellable>()

    func transform(input: Input) -> Output {
        let validateBlogAddress = input.blogAddressTextFieldDidEdit
            .map { address in
                LogInManager.shared.blodURL = address
                return Validator.validate(blogLink: address) ? true : false
            }
            .eraseToAnyPublisher()

        let signUpWithNextButton = input.nextButtonDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .flatMap { _ in
                return FireFunctionsManager.blogTitle(
                    link: LogInManager.shared.blodURL
                )
                .eraseToAnyPublisher()
            }
            .catch { _ in
                return Just("").eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        let signUpWithBlogTitle = input.blogTitleConfirmDidTap
            .flatMap { title -> AnyPublisher<User, Error> in
                return Future<User, Error> { promise in
                    guard let user = try? self.createUser(
                        blogURL: LogInManager.shared.blodURL,
                        blogTitle: title
                    ) else {
                        promise(.failure(FirebaseAuthError.fetchUUIDError))
                        return
                    }
                    promise(.success(user))
                }
                .eraseToAnyPublisher()
            }
            // TODO: 유저 저장 후 완료 됐다는 메시지 전달
//            .flatMap { user in
//                return FirestoreUser.save(user: user).eraseToAnyPublisher()
//            }
            .eraseToAnyPublisher()

        let signUpWithSkipButton = input.skipConfirmDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .flatMap { _ -> AnyPublisher<User, Error> in
                return Future<User, Error> { promise in
                    guard let user = try? self.createUser(blogURL: "", blogTitle: "") else {
                        promise(.failure(FirebaseAuthError.fetchUUIDError))
                        return
                    }
                    promise(.success(user))
                }
                .eraseToAnyPublisher()
            }
            // TODO: 유저 저장 후 완료 됐다는 메시지 전달
//            .flatMap { user -> AnyPublisher<User, Error> in
//                return FirestoreUser.save(user: user).eraseToAnyPublisher()
//            }
            .eraseToAnyPublisher()

        input.saveFCMToken
            .sink { _ in self.saveFCMToken() }
            .store(in: &cancelBag)

        return Output(
            validateBlogAddress: validateBlogAddress,
            signUpWithNextButton: signUpWithNextButton,
            signUpWithBlogTitle: signUpWithBlogTitle,
            signUpWithSkipButton: signUpWithSkipButton
        )
    }

    private func createUser(blogURL: String, blogTitle: String) throws -> User {
        guard let userUUID = LogInManager.shared.userUUID else {
            throw FirebaseAuthError.fetchUUIDError
        }

        var blogURL = blogURL
        if let lastIndex = blogURL.lastIndex(of: "/"),
           lastIndex == blogURL.index(before: blogURL.endIndex) {
            blogURL.removeLast()
        }

        return User(
            userUUID: userUUID,
            nickname: LogInManager.shared.nickname,
            profileImageURL: "https://github.com/\(LogInManager.shared.nickname).png",
            domain: LogInManager.shared.domain,
            camperID: LogInManager.shared.camperID,
            ordinalNumber: 7,
            blogURL: blogURL,
            blogTitle: blogTitle,
            scrapFeedUUIDs: [],
            signupDate: Date(),
            isPushOn: false
        )
    }

    private func saveFCMToken() {
        guard let fcmToken = UserDefaultsManager.fcmToken() else { return }
        let userUUID = UserManager.shared.user.userUUID
        Task { [weak self] in
            try await self?.bcFireStoreService.saveFCMToken(fcmToken, to: userUUID)
        }
    }
}
