//
//  BCFirebaseAuthService.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

import FirebaseAuth

public protocol BCFirebaseAuthServiceProtocol {
    func getCurrentUserUid() throws -> String

    func loginWithGithub(token: String) async throws -> String
    func withdrawalWithGithub(token: String) async throws

    func loginWithApple(idTokenString: String, nonce: String) async throws -> String
    func withdrawalWithApple(idTokenString: String, nonce: String) async throws

    func signOut() throws
}

public final class BCFirebaseAuthService: BCFirebaseAuthServiceProtocol {

    private let auth = Auth.auth()

    public func getCurrentUserUid() throws -> String {
        if let user = auth.currentUser {
            return user.uid
        }
        throw FirebaseAuthError.currentUserNil
    }

    public func loginWithGithub(token: String) async throws -> String {
        let credential = GitHubAuthProvider.credential(withToken: token)

        let result = try await auth.signIn(with: credential)
        return result.user.uid
    }

    public func withdrawalWithGithub(token: String) async throws {
        let credential = GitHubAuthProvider.credential(withToken: token)
        try await auth.currentUser?.reauthenticate(with: credential)
        try await auth.currentUser?.delete()
        try auth.signOut()
    }

    public func loginWithApple(idTokenString: String, nonce: String) async throws -> String {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        let result = try await auth.signIn(with: credential)
        return result.user.uid
    }

    public func withdrawalWithApple(idTokenString: String, nonce: String) async throws {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        try await auth.currentUser?.reauthenticate(with: credential)
        try await auth.currentUser?.delete()
        try auth.signOut()
    }

    public func signOut() throws {
        try auth.signOut()
    }
}
