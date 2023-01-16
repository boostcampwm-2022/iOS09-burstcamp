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
    func signInToFirebase(token: String) async throws
    func withdrawal(token: String) async throws
}

final class BCFirebaseAuthService: BCFirebaseAuthServiceProtocol {

    let auth = Auth.auth()

    func getCurrentUserUid() throws -> String {
        if let user = auth.currentUser {
            debugPrint("BCFirebaseAuth \(user.uid)")
            return user.uid
        }
        throw FirebaseAuthError.currentUserNil
    }

    func signInToFirebase(token: String) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            let credential = GitHubAuthProvider.credential(withToken: token)

            auth.signIn(with: credential) { result, error in
                guard let result = result, error == nil else {
                    continuation.resume(throwing: FirebaseAuthError.failSignInError)
                    return
                }
                continuation.resume()
            }
        })
        as Void
    }

    func withdrawal(token: String) async throws {
        let credential = GitHubAuthProvider.credential(withToken: token)
        try await auth.currentUser?.reauthenticate(with: credential)
        try await auth.currentUser?.delete()
        try auth.signOut()
    }
}
