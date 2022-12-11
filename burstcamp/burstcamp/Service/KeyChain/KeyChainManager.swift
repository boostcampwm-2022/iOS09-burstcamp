//
//  KeyChainManager.swift
//  burstcamp
//
//  Created by neuli on 2022/12/03.
//

import Foundation
import Security

struct KeyChainManager {

    static let userAccount = "userAccount"
    static let githubToken = "githubToken"

    static func save(user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }

        let query = saveUserQuery(data: data)
        SecItemAdd(query, nil)
    }

    static func save(token: String) {
        guard let data = try? JSONEncoder().encode(token) else { return }

        let query = saveTokenQuery(data: data)
        SecItemAdd(query, nil)
    }

    static func readUser() -> User? {
        let query = readUserQuery()
        var item: CFTypeRef?

        if SecItemCopyMatching(query, &item) != errSecSuccess { return nil }

        guard let item = item as? [CFString: Any],
              let data = item[kSecAttrGeneric] as? Data,
              let user = try? JSONDecoder().decode(User.self, from: data)
        else { return nil }
        return user
    }

    static func readToken() -> String? {
        let query = readTokenQuery()
        var item: CFTypeRef?

        if SecItemCopyMatching(query, &item) != errSecSuccess { return nil }

        guard let item = item as? [CFString: Any],
              let data = item[kSecAttrGeneric] as? Data,
              let token = try? JSONDecoder().decode(String.self, from: data)
        else { return nil }
        return token
    }

    static func deleteUser() {
        let query = deleteUserQuery()
        SecItemDelete(query)
    }

    static func deleteToken() {
        let query = deleteTokenQuery()
        SecItemDelete(query)
    }

    private static func saveUserQuery(data: Data) -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: userAccount,
            kSecAttrGeneric: data
        ] as CFDictionary
    }

    private static func saveTokenQuery(data: Data) -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: githubToken,
            kSecAttrGeneric: data
        ] as CFDictionary
    }

    private static func readUserQuery() -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: userAccount,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary
    }

    private static func readTokenQuery() -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: githubToken,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary
    }

    private static func deleteUserQuery() -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: userAccount
        ] as CFDictionary
    }

    private static func deleteTokenQuery() -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: githubToken
        ] as CFDictionary
    }
}
