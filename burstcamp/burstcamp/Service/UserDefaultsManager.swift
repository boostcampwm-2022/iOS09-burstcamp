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
    private static let isForegroundKey = "isForeground"
    private static let notificationFeedUUIDKey = "notificationFeedUUIDKey"

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

    // TODO: 이미지 메모리 캐시 etag 정보 앱 종료시 모두 삭제 ㅇㅅㅇ..

    // FCMToken
    static func save(fcmToken: String) {
        UserDefaults.standard.set(fcmToken, forKey: fcmToken)
    }

    static func fcmToken() -> String? {
        return UserDefaults.standard.string(forKey: fcmTokenKey)
    }

    // isBackground
    static func save(isForeground: String) {
        UserDefaults.standard.set(isForeground, forKey: isForegroundKey)
    }

    static func isForeground() -> String? {
        return UserDefaults.standard.string(forKey: isForegroundKey)
    }

    static func removeIsForeground() {
        UserDefaults.standard.removeObject(forKey: isForegroundKey)
    }

    // notificationFeedUUID
    static func save(notificationFeedUUID: String) {
        UserDefaults.standard.set(notificationFeedUUID, forKey: notificationFeedUUIDKey)
    }

    static func notificationFeedUUID() -> String? {
        return UserDefaults.standard.string(forKey: notificationFeedUUIDKey)
    }

    static func removeNotificationFeedUUID() {
        UserDefaults.standard.removeObject(forKey: notificationFeedUUIDKey)
    }
}
