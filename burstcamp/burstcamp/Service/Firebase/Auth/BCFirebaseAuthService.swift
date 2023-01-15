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
    func signInToFirebase(token: String) throws
    func withdrawal(token: String) throws
}

final class BCFirebaseAuthService: BCFirebaseAuthServiceProtocol {

    let auth = Auth.auth()

    func getCurrentUserUid() throws -> String {
        if let user = auth.currentUser {
            return user.uid
        }
        throw FirebaseAuthError.currentUserNil
    }

    func signInToFirebase(token: String) throws {
    }

    func withdrawal(token: String) throws {
        let credential = GitHubAuthProvider.credential(withToken: token)
        auth.currentUser?.reauthenticate(with: credential, completion: { _, error in
            print(error)
        })
    }
}
