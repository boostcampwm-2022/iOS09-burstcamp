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

    static func deleteUser() {
        let query = deleteUserQuery()
        SecItemDelete(query)
    }

    private static func saveUserQuery(data: Data) -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: userAccount,
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

    private static func deleteUserQuery() -> CFDictionary {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: userAccount
        ] as CFDictionary
    }
}
