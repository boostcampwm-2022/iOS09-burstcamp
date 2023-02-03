//
//  DependencyFactory.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DependencyFactory: DependencyFactoryProtocol {

    private var signUpUseCase: SignUpUseCase?

    // MARK: - UseCase
    private func createDefaultSignUpUseCase() -> SignUpUseCase {
        let userRepository = createUserRepository()
        let blogRepository = createBlogRepository()
        return DefaultSignUpUseCase(
            userRepository: userRepository,
            blogRepository: blogRepository
        )
    }

    // MARK: - Repository
    private func createFeedRepository() -> FeedRepository {
        let bcFirestoreService = BCFirestoreService()
        let feedMockUpDatSource = DefaultFeedMockUpDataSource()
        return DefaultFeedRepository(
            bcFirestoreService: bcFirestoreService,
            feedMockUpDataSource: feedMockUpDatSource
        )
    }

    private func createLoginRepository() -> LoginRepository {
        let bcFirebaseAuthService = BCFirebaseAuthService()
        let bcFirebaseFunctionService = BCFirebaseFunctionService()
        let githubLoginDataSource = GithubLoginDatasource()
        return DefaultLoginRepository(
            bcFirebaseAuthService: bcFirebaseAuthService,
            bcFirebaseFunctionService: bcFirebaseFunctionService,
            githubLoginDataSource: githubLoginDataSource
        )
    }

    private func createBlogRepository() -> BlogRepository {
        let bcFirebaseFunctionService = BCFirebaseFunctionService()
        return DefaultBlogRepository(
            bcFirebaseFunctionService: bcFirebaseFunctionService
        )
    }

    private func createUserRepository() -> UserRepository {
        let bcFirestoreService = BCFirestoreService()
        let bcFirebaseFunctionService = BCFirebaseFunctionService()
        return DefaultUserRepository(
            bcFirestoreService: bcFirestoreService,
            bcFirebaseFunctionService: bcFirebaseFunctionService
        )
    }
}

extension DependencyFactory {

    // MARK: - UseCase()
    func createNotificationUseCase() -> NotificationUseCase {
        let userDefaultsService = DefaultUserDefaultsService()
        let bcFireStoreService = BCFirestoreService()
        let notificationRepository = DefaultNotificationRepository(
            userDefaultsService: userDefaultsService,
            bcFirestoreService: bcFireStoreService
        )
        return DefaultNotificationUseCase(notificationRepository: notificationRepository)
    }

    func createLoginUseCase() -> LoginUseCase {
        let loginRepository = createLoginRepository()
        let userRepository = createUserRepository()
        return DefaultLoginUseCase(loginRepository: loginRepository, userRepository: userRepository)
    }

    // MARK: - ViewModel
    func createLoginViewModel() -> LogInViewModel {
        let loginUseCase = createLoginUseCase()
        return LogInViewModel(loginUseCase: loginUseCase)
    }

    func createSignUpDomainViewModel(userNickname: String) -> SignUpDomainViewModel {
        if let signUpUseCase = signUpUseCase {
            signUpUseCase.setUserNickname(userNickname)
            return SignUpDomainViewModel(signUpUseCase: signUpUseCase)
        } else {
            let signUpUseCase = createDefaultSignUpUseCase()
            signUpUseCase.setUserNickname(userNickname)
            self.signUpUseCase = signUpUseCase
            return SignUpDomainViewModel(signUpUseCase: signUpUseCase)
        }
    }

    func createSignUpCamperIDViewModel() -> SignUpCamperIDViewModel {
        if let signUpUseCase = signUpUseCase {
            return SignUpCamperIDViewModel(signUpUseCase: signUpUseCase)
        } else {
            let signUpUseCase = createDefaultSignUpUseCase()
            self.signUpUseCase = signUpUseCase
            return SignUpCamperIDViewModel(signUpUseCase: signUpUseCase)
        }
    }

    func createSignUpBlogViewModel() -> SignUpBlogViewModel {
        if let signUpUseCase = signUpUseCase {
            return SignUpBlogViewModel(signUpUseCase: signUpUseCase)
        } else {
            let signUpUseCase = createDefaultSignUpUseCase()
            self.signUpUseCase = signUpUseCase
            return SignUpBlogViewModel(signUpUseCase: signUpUseCase)
        }
    }

    func createHomeViewModel() -> HomeViewModel {
        let feedRepository = createFeedRepository()
        let userRepository = createUserRepository()
        let homeUseCase = DefaultHomeUseCase(feedRepository: feedRepository, userRepository: userRepository)
        return HomeViewModel(homeUseCase: homeUseCase)
    }

    func createScrapPageViewModel() -> ScrapPageViewModel {
        let feedRepository = createFeedRepository()
        let scrapPageUseCase = DefaultScrapPageUseCase(feedRepository: feedRepository)
        return ScrapPageViewModel(scrapPageUseCase: scrapPageUseCase)
    }

    func createFeedDetailViewModel(feed: Feed) -> FeedDetailViewModel {
        let feedRepository = createFeedRepository()
        let feedDetailUseCase = DefaultFeedDetailUseCase(feedRepository: feedRepository)
        return FeedDetailViewModel(feedDetailUseCase: feedDetailUseCase, feed: feed)
    }

    func createFeedDetailViewModel(feedUUID: String) -> FeedDetailViewModel {
        let feedRepository = createFeedRepository()
        let feedDetailUseCase = DefaultFeedDetailUseCase(feedRepository: feedRepository)
        return FeedDetailViewModel(feedDetailUseCase: feedDetailUseCase, feedUUID: feedUUID)
    }

    func createMyPageViewModel() -> MyPageViewModel {
        let loginRepository = createLoginRepository()
        let userRepository = createUserRepository()
        let imageRepository = DefaultImageRepository(bcFirestorageService: BCFireStorageService())
        let myPageUseCase = DefaultMyPageUseCase(
            loginRepository: loginRepository,
            userRepository: userRepository,
            imageRepository: imageRepository
        )
        return MyPageViewModel(myPageUseCase: myPageUseCase)
    }

    func createMyPageEditViewModel() -> MyPageEditViewModel {
        let imageRepository = DefaultImageRepository(bcFirestorageService: BCFireStorageService())
        let userRepository = createUserRepository()
        let myPageEditUseCase = DefaultMyPageEditUseCase(
            imageRepository: imageRepository,
            userRepository: userRepository
        )
        return MyPageEditViewModel(myPageEditUseCase: myPageEditUseCase)
    }
}
