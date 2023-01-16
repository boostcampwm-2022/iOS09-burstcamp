//
//  DependencyFactory.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DependencyFactory: DependencyFactoryProtocol {

    private var signUpUseCase: SignUpUseCase?

    private func createDefaultSignUpUseCase() -> SignUpUseCase {
        return DefaultSignUpUseCase(
            signUpRepository: DefaultSignUpRepository(),
            userRepository: DefaultUserRepository(),
            blogRepository: DefaultBlogRepository()
        )
    }
}

extension DependencyFactory {
    func createLoginUseCase() -> LoginUseCase {
        let githubLoginDataSource = GithubLoginDatasource()
        let loginRepository = DefaultLoginRepository(githubLoginDataSource: githubLoginDataSource)
        return DefaultLoginUseCase(loginRepository: loginRepository)
    }

    func createLoginViewModel() -> LogInViewModel {
        let loginUseCase = createLoginUseCase()
        return LogInViewModel(loginUseCase: loginUseCase)
    }

    func createSignUpDomainViewModel() -> SignUpDomainViewModel {
        if let signUpUseCase = signUpUseCase {
            return SignUpDomainViewModel(signUpUseCase: signUpUseCase)
        } else {
            let signUpUseCase = createDefaultSignUpUseCase()
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
        let homeUseCase = DefaultHomeUseCase()
        return HomeViewModel(homeUseCase: homeUseCase)
    }

    func createScrapPageViewModel() -> ScrapPageViewModel {
        let scrapPageUseCase = DefaultScrapPageUseCase()
        return ScrapPageViewModel(scrapPageUseCase: scrapPageUseCase)
    }

    func createFeedDetailViewModel(feed: Feed) -> FeedDetailViewModel {
        let feedDetailUseCase = DefaultFeedDetailUseCase()
        return FeedDetailViewModel(feedDetailUseCase: feedDetailUseCase, feed: feed)
    }

    func createFeedDetailViewModel(feedUUID: String) -> FeedDetailViewModel {
        let feedDetailUseCase = DefaultFeedDetailUseCase()
        return FeedDetailViewModel(feedDetailUseCase: feedDetailUseCase, feedUUID: feedUUID)
    }

    func createMyPageViewModel() -> MyPageViewModel {
        let myPageUseCase = DefaultMyPageUseCase()
        return MyPageViewModel(myPageUseCase: myPageUseCase)
    }

    func createMyPageEditViewModel() -> MyPageEditViewModel {
        let myPageEditUseCase = DefaultMyPageEditUseCase()
        return MyPageEditViewModel(myPageEditUseCase: myPageEditUseCase)
    }
}
