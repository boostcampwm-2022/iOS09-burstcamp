//
//  LoginViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import AuthenticationServices
import Combine
import SafariServices
import UIKit

import SnapKit
import Then

final class LogInViewController: UIViewController {

    private var logInView: LogInView {
        guard let view = view as? LogInView else { return LogInView() }
        return view
    }

    private var currentNonce: String?

    var coordinatorPublisher = PassthroughSubject<AuthCoordinatorEvent, Never>()
    private var cancelBag = Set<AnyCancellable>()

    private let viewModel: LogInViewModel

    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = LogInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func showIndicator() {
        DispatchQueue.main.async {
            self.logInView.activityIndicator.startAnimating()
            self.logInView.loadingLabel.isHidden = false
            self.logInView.camperAuthButton.isEnabled = false
            self.setUserInteraction(isEnabled: false)
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async {
            self.logInView.activityIndicator.stopAnimating()
            self.logInView.loadingLabel.isHidden = true
            self.logInView.camperAuthButton.isEnabled = true
            self.setUserInteraction(isEnabled: true)
        }
    }

    func loginWithGithub(code: String) {
        Task { [weak self] in
            self?.showIndicator()
            do {
                try await self?.viewModel.loginWithGithub(code: code)
            } catch {
                self?.showAlert(message: error.localizedDescription)
            }
            self?.hideIndicator()
        }
    }

    private func bind() {

        let input = LogInViewModel.Input(
            logInButtonDidTap: logInView.camperAuthButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.openLogInView
            .sink { [weak self] _ in
                self?.coordinatorPublisher.send(.moveToGithubLogIn)
            }
            .store(in: &cancelBag)

        output.moveToOtherView
            .sink { [weak self] logInEvent in
                self?.logInView.activityIndicator.stopAnimating()
                self?.logInView.loadingLabel.isHidden = true
                self?.logInView.camperAuthButton.isEnabled = true

                switch logInEvent {
                case .moveToDomainScreen(let userNickname):
                    self?.coordinatorPublisher.send(.moveToDomainScreen(userNickname: userNickname))
                case .moveToTabBarScreen:
                    self?.coordinatorPublisher.send(.moveToTabBarScreen)
                case .showAlert(let message):
                    self?.showAlert(message: message)
                case .moveToBlogScreen, .moveToIDScreen, .moveToGithubLogIn:
                    return
                }
            }
            .store(in: &cancelBag)
    }

    private func loginWithApple(idTokenString: String, nonce: String) {
        Task { [weak self] in
            self?.showIndicator()
            do {
                try await self?.viewModel.loginWithApple(idTokenString: idTokenString, nonce: nonce)
            } catch {
                self?.showAlert(message: "애플 로그인에 실패했습니다. \(error.localizedDescription)")
            }
            self?.hideIndicator()
        }
    }
}

extension LogInViewController: ASAuthorizationControllerPresentationContextProviding,
                                ASAuthorizationControllerDelegate {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256()

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            loginWithApple(idTokenString: idTokenString, nonce: nonce)
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
}
