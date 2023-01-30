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

    func loginWithGithub(token: String) async throws -> String
    func withdrawalWithGithub(token: String) async throws

    func loginWithApple(idTokenString: String, nonce: String) async throws -> String
    func withdrawalWithApple(idTokenString: String, nonce: String) async throws
}

final class BCFirebaseAuthService: BCFirebaseAuthServiceProtocol {

    let auth = Auth.auth()

    func getCurrentUserUid() throws -> String {
        if let user = auth.currentUser {
            return user.uid
        }
        throw FirebaseAuthError.currentUserNil
    }

    func loginWithGithub(token: String) async throws -> String {
        let credential = GitHubAuthProvider.credential(withToken: token)

        let result = try await auth.signIn(with: credential)
        return result.user.uid
    }

    func withdrawalWithGithub(token: String) async throws {
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
