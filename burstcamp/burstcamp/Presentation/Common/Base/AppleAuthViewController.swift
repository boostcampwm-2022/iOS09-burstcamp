//
//  AppleAuthViewController.swift
//  burstcamp
//
//  Created by youtak on 2023/01/30.
//

import AuthenticationServices
import UIKit

class AppleAuthViewController: UIViewController,
                                ASAuthorizationControllerPresentationContextProviding {

    private(set) var currentNonce: String?

    func getAppleLoginRequest() -> ASAuthorizationAppleIDRequest {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256()

        return request
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else { fatalError("애플 로그인 ASPresentationAnchor 에러")}
        return window
    }
}
