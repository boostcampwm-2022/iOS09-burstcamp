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
        return false
    }

    func openGithubLoginView() {
        let urlString = "https://github.com/login/oauth/authorize"
        guard var component = URLComponents(string: urlString),
              let clientID = githubAPIKey?.clientID
        else { return }
        component.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "admin:org")
        ]
        guard let url = component.url else { return }
        UIApplication.shared.open(url)
//        guard let clientID = githubAPIKey?.clientID,
//              let url = URL(string: urlString + "?client_id=\(clientID)")
//        else { return }
//
//        UIApplication.shared.open(url)
    }

    func logIn(code: String) {
        var token: String = ""
        var nickName: String = ""
        var memberType: String = ""

        requestGithubAccessToken(code: code)
            .map { $0.accessToken }
            .flatMap { accessToken -> AnyPublisher<String, NetworkError> in
                token = accessToken
                return self.requestGithubUserInfo(token: accessToken)
            }
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
                print(gitMembership.organization.login) // "boostcampwm-2022"
                
                //TODO: 멤버면서 이미 회원이면

                //TODO: 멤버인데 회원 가입해야하면
            }
            .store(in: &cancelBag)
    }

    func requestGithubAccessToken(code: String) -> AnyPublisher<GithubToken, NetworkError> {
        let urlString = "https://github.com/login/oauth/access_token"

        guard let githubAPIKey = githubAPIKey,
              let url = URL(string: urlString)
        else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }

        let bodyInfos: [String: String] = [
            "client_id": githubAPIKey.clientID,
            "client_secret": githubAPIKey.clientSecret,
            "code": code
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyInfos)
        else {
            return Fail(error: NetworkError.encodeError).eraseToAnyPublisher()
        }

        let httpHeaders = [
            (key: "Content-Type", value: "application/json"),
            (key: "Accept", value: "application/json")
        ]

        let request = URLSessionService.makeRequest(
            url: url,
            httpMethod: .POST,
            httpBody: bodyData,
            httpHeaders: httpHeaders
        )

        return URLSessionService.request(with: request)
            .decode(type: GithubToken.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodeError }
            .eraseToAnyPublisher()
    }

    func requestGithubUserInfo(token: String) -> AnyPublisher<String, NetworkError> {
        let urlString = "https:/api.github.com/user"
        guard let url = URL(string: urlString)
        else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }

        let httpHeaders = [
            (key: "Content-Type", value: "application/json"),
            (key: "Accept", value: "application/vnd.github+json"),
            (key: "Authorization", value: "Bearer \(token)")
        ]

        let request = URLSessionService.makeRequest(
            url: url,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return URLSessionService.request(with: request)
            .map { userInfo in
                guard let userJSON = try? JSONSerialization.jsonObject(
                    with: userInfo, options: []) as? [String: Any],
                      let nickName = userJSON["login"] as? String
                else { return "" }
                return nickName
            }
            .eraseToAnyPublisher()
    }

    func getOrganizationMembership(
        nickName: String,
        token: String
    ) -> AnyPublisher<GithubMembership, NetworkError> {
        let urlString = "https://api.github.com/orgs/boostcampwm-2022/memberships/\(nickName)"

        guard let url = URL(string: urlString)
        else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }

        let httpHeaders = [
            (key: "Content-Type", value: "application/json"),
            (key: "Accept", value: "application/vnd.github+json"),
            (key: "Authorization", value: "Bearer \(token)")
        ]

        let request = URLSessionService.makeRequest(
            url: url,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return URLSessionService.request(with: request)
            .decode(type: GithubMembership.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodeError }
            .eraseToAnyPublisher()
    }
}
