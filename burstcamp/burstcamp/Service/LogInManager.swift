//
//  LogInManager.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Combine
import UIKit

final class LogInManager {

    static let shared = LogInManager()

    private init () {}

    private var cancelBag = Set<AnyCancellable>()

    private var githubAPIKey: Github? {
        guard let serviceInfoURL = Bundle.main.url(
            forResource: "Service-Info",
            withExtension: "plist"
        ),
              let data = try? Data(contentsOf: serviceInfoURL),
              let apiKey = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else { return nil }
        return apiKey.github
    }

    func isLoggedIn() -> Bool {
        return true
    }

    func openGithubLoginView() {
        let urlString = "https://github.com/login/oauth/authorize"

        guard var urlComponent = URLComponents(string: urlString),
              let clientID = githubAPIKey?.clientID
        else {
            return
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "admin:org")
        ]

        guard let url = urlComponent.url else { return }

        UIApplication.shared.open(url)
    }

    func logIn(code: String) {
        var token: String = ""
        var nickName: String = ""

        requestGithubAccessToken(code: code)
            .map { $0.accessToken }
            .flatMap { accessToken -> AnyPublisher<GithubUser, NetworkError> in
                token = accessToken
                return self.requestGithubUserInfo(token: accessToken)
            }
            .map { $0.login }
            .flatMap { name -> AnyPublisher<GithubMembership, NetworkError> in
                nickName = name
                return self.getOrganizationMembership(nickName: nickName, token: token)
            }
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure:
                    //TODO: 부캠 멤버가 아니라면 alert
                    print("failure")
                }
            } receiveValue: { gitMembership in
                print(gitMembership.user.login)

                //TODO: 멤버면서 이미 회원이면

                //TODO: 멤버인데 회원 가입해야하면
            }
            .store(in: &cancelBag)
    }

    func requestGithubAccessToken(code: String) -> AnyPublisher<GithubToken, NetworkError> {
        let urlString = "https://github.com/login/oauth/access_token"

        guard let githubAPIKey = githubAPIKey
        else {
            return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
        }

        let bodyInfos: [String: String] = [
            "client_id": githubAPIKey.clientID,
            "client_secret": githubAPIKey.clientSecret,
            "code": code
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyInfos)
        else {
            return Fail(error: NetworkError.encodingError)
                .eraseToAnyPublisher()
        }

        let httpHeaders = [
            HTTPHeader.contentType_applicationJSON.keyValue,
            HTTPHeader.accept_applicationJSON.keyValue
        ]

        let request = URLSessionService.request(
            urlString: urlString,
            httpMethod: .POST,
            httpHeaders: httpHeaders,
            httpBody: bodyData
        )

        return request
            .decode(type: GithubToken.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.responseDecoingError }
            .eraseToAnyPublisher()
    }

    func requestGithubUserInfo(token: String) -> AnyPublisher<GithubUser, NetworkError> {
        let urlString = "https:/api.github.com/user"

        let httpHeaders = [
            HTTPHeader.contentType_applicationJSON.keyValue,
            HTTPHeader.accept_application_vndGithubJSON.keyValue,
            HTTPHeader.authorization_Bearer(token: token).keyValue
        ]

        let request = URLSessionService.request(
            urlString: urlString,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return request
            .decode(type: GithubUser.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.responseDecoingError }
            .eraseToAnyPublisher()
    }

    func getOrganizationMembership(
        nickName: String,
        token: String
    ) -> AnyPublisher<GithubMembership, NetworkError> {
        let urlString = "https://api.github.com/orgs/boostcampwm-2022/memberships/\(nickName)"

        let httpHeaders = [
            HTTPHeader.contentType_applicationJSON.keyValue,
            HTTPHeader.accept_application_vndGithubJSON.keyValue,
            HTTPHeader.authorization_Bearer(token: token).keyValue
        ]

        let request = URLSessionService.request(
            urlString: urlString,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return request
            .decode(type: GithubMembership.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.responseDecoingError }
            .eraseToAnyPublisher()
    }
}
