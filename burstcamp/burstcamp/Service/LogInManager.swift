//
//  LogInManager.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Combine
import UIKit

import FirebaseAuth

final class LogInManager {

    static let shared = LogInManager()

    private init () {}

    private var cancelBag = Set<AnyCancellable>()

    var autoLogInPublisher = PassthroughSubject<Bool, Never>()
    var logInPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()

    var userUUID: String? {
        return Auth.auth().currentUser?.uid
    }

    var token: String = ""
    var nickname: String = ""

    var domain: Domain = .iOS
    var camperID: String = ""
    var blodURL: String = ""

    var githubAPIKey: Github? {
        guard let serviceInfoURL = Bundle.main.url(
            forResource: "Service-Info",
            withExtension: "plist"
        ),
              let data = try? Data(contentsOf: serviceInfoURL),
              let apiKey = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else { return nil }
        return apiKey.github
    }

    func isLoggedIn() {
        guard let userUUID = userUUID else {
            autoLogInPublisher.send(false)
            return
        }

        FirestoreUser.fetch(userUUID: userUUID)
            .sink { [weak self] result in
                if case .failure = result {
                    self?.autoLogInPublisher.send(false)
                }
            } receiveValue: { [weak self] _ in
                self?.autoLogInPublisher.send(true)
            }
            .store(in: &cancelBag)
    }

    func logIn(code: String) {
        requestGithubAccessToken(code: code)
            .map { $0.accessToken }
            .flatMap { accessToken -> AnyPublisher<GithubUser, GithubError> in
                self.token = accessToken
                return self.requestGithubUserInfo(token: accessToken)
            }
            .map { $0.login }
            .flatMap { nickname -> AnyPublisher<GithubMembership, GithubError> in
                self.nickname = nickname
                return self.getOrganizationMembership(nickname: nickname, token: self.token)
            }
            .receive(on: DispatchQueue.main)
            .sink { result in
                if case .failure(let error) = result {
                    self.logInPublisher.send(.showAlert(error.errorDescription ?? ""))
                }
            } receiveValue: { _ in
                self.signInToFirebase(token: self.token)
            }
            .store(in: &cancelBag)
    }

    func signInToFirebase(token: String) {
        let credential = GitHubAuthProvider.credential(withToken: token)

        Auth.auth().signIn(with: credential) { result, error in
            guard let result = result,
                  error == nil
            else {
                self.logInPublisher.send(
                    .showAlert(FirebaseAuthError.failSignInError.errorDescription ?? "")
                )
                return
            }

            KeyChainManager.save(token: token)
            self.isSignedUp(uuid: result.user.uid)
        }
    }

    func isSignedUp(uuid: String) {
        FirestoreUser.fetch(userUUID: uuid)
            .sink {  result in
                if case .failure = result {
                    self.logInPublisher.send(.moveToDomainScreen)
                }
            } receiveValue: {  _ in
                self.logInPublisher.send(.moveToTabBarScreen)
            }
            .store(in: &cancelBag)
    }

    func signOut() -> AnyPublisher<Bool, FirebaseAuthError> {
        return Future<Bool, FirebaseAuthError> { promise in

            guard let token = KeyChainManager.readToken() else {
                promise(.failure(.readTokenError))
                return
            }

            let credential = GitHubAuthProvider.credential(withToken: token)

            Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
                if error != nil {
                    promise(.failure(.userReAuthError))
                } else {
                    Auth.auth().currentUser?.delete { error in
                        if error != nil {
                            promise(.failure(.userDeleteError))
                        } else {
                            FirestoreUser.delete(user: UserManager.shared.user)
                            guard (try? Auth.auth().signOut()) != nil else {
                                promise(.failure(.authSignOutError))
                                return
                            }
                            promise(.success(true))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func requestGithubAccessToken(code: String) -> AnyPublisher<GithubToken, GithubError> {
        let urlString = "https://github.com/login/oauth/access_token"

        guard let githubAPIKey = githubAPIKey
        else {
            return Fail(error: GithubError.APIKeyError).eraseToAnyPublisher()
        }

        let bodyInfos: [String: String] = [
            "client_id": githubAPIKey.clientID,
            "client_secret": githubAPIKey.clientSecret,
            "code": code
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyInfos)
        else {
            return Fail(error: GithubError.encodingError)
                .eraseToAnyPublisher()
        }

        let httpHeaders = [
            HTTPHeader.contentTypeApplicationJSON.keyValue,
            HTTPHeader.acceptApplicationJSON.keyValue
        ]

        let request = URLSessionService.request(
            urlString: urlString,
            httpMethod: .POST,
            httpHeaders: httpHeaders,
            httpBody: bodyData
        )

        return request
            .decode(type: GithubToken.self, decoder: JSONDecoder())
            .mapError { _ in GithubError.requestAccessTokenError }
            .eraseToAnyPublisher()
    }

    func requestGithubUserInfo(token: String) -> AnyPublisher<GithubUser, GithubError> {
        let urlString = "https:/api.github.com/user"

        let httpHeaders = [
            HTTPHeader.contentTypeApplicationJSON.keyValue,
            HTTPHeader.acceptApplicationVNDGithubJSON.keyValue,
            HTTPHeader.authorizationBearer(token: token).keyValue
        ]

        let request = URLSessionService.request(
            urlString: urlString,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return request
            .decode(type: GithubUser.self, decoder: JSONDecoder())
            .mapError { _ in GithubError.requestUserInfoError }
            .eraseToAnyPublisher()
    }

    func getOrganizationMembership(
        nickname: String,
        token: String
    ) -> AnyPublisher<GithubMembership, GithubError> {
        let urlString = "https://api.github.com/orgs/boostcampwm-2022/memberships/\(nickname)"

        let httpHeaders = [
            HTTPHeader.contentTypeApplicationJSON.keyValue,
            HTTPHeader.acceptApplicationVNDGithubJSON.keyValue,
            HTTPHeader.authorizationBearer(token: token).keyValue
        ]

        let request = URLSessionService.request(
            urlString: urlString,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return request
            .decode(type: GithubMembership.self, decoder: JSONDecoder())
            .mapError { _ in GithubError.checkOrganizationError }
            .eraseToAnyPublisher()
    }
}
