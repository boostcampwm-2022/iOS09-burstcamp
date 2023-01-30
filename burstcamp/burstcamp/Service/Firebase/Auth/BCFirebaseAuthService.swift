//
//  BCFirebaseAuthService.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

import FirebaseAuth

protocol BCFirebaseAuthServiceProtocol {
    func getCurrentUserUid() throws -> String
    func signInToFirebase(token: String) async throws -> String
    func withdrawal(token: String) async throws
}

final class BCFirebaseAuthService: BCFirebaseAuthServiceProtocol {

    let auth = Auth.auth()

    func getCurrentUserUid() throws -> String {
        if let user = auth.currentUser {
            return user.uid
        }
        throw FirebaseAuthError.currentUserNil
    }

    func signInToFirebase(token: String) async throws -> String {
        try await withCheckedThrowingContinuation({ continuation in
            let credential = GitHubAuthProvider.credential(withToken: token)

            auth.signIn(with: credential) { result, error in
                guard let result = result, error == nil else {
                    continuation.resume(throwing: FirebaseAuthError.failSignIn)
                    return
                }
                continuation.resume(returning: result.user.uid)
            }
        })
    }

    func withdrawal(token: String) async throws {
        let credential = GitHubAuthProvider.credential(withToken: token)
        try await auth.currentUser?.reauthenticate(with: credential)
        try await auth.currentUser?.delete()
        try auth.signOut()
    }

    func loginWithApple(idTokenString: String, nonce: String) async throws -> String {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        let result = try await auth.signIn(with: credential)
        return result.user.uid
    }

    func withdrawalWithApple(idTokenString: String, nonce: String) async throws {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        try await auth.currentUser?.reauthenticate(with: credential)
        try await auth.currentUser?.delete()
        try auth.signOut()
    }
}
