//
//  UserDefaultManager.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import Foundation

struct UserDefaultsManager {

    private static let appearanceKey = "Appearance"
    private static let fcmTokenKey = "fcmTokenKey"

    // dark mode
    static func saveAppearance(appearance: Appearance) {
        UserDefaults.standard.set(appearance.theme, forKey: appearanceKey)
    }

    static func currentAppearance() -> Appearance {
        guard let appearanceString = UserDefaults.standard.string(forKey: appearanceKey),
              let currentAppearance = Appearance(rawValue: appearanceString)
        else { return .light }
        return currentAppearance
    }

    // etag
    static func save(etag: String, urlString: String) {
        UserDefaults.standard.set(etag, forKey: urlString)
    }

    static func etag(urlString: String) -> String? {
        return UserDefaults.standard.string(forKey: urlString)
    }

    // FCMToken
    static func save(fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: fcmToken)
    }

    static func fcmToken() -> String? {
        return UserDefaults.standard.string(forKey: fcmTokenKey)
    }
}
