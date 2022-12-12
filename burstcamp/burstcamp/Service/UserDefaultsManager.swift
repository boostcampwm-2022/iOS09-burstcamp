//
//  UserDefaultManager.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import Foundation

struct UserDefaultsManager {

    private static let appearanceKey = "AppearanceKey"
    private static let fcmTokenKey = "fcmTokenKey"
    private static let isForegroundKey = "isForegroundKey"
    private static let notificationFeedUUIDKey = "notificationFeedUUIDKey"

    private static var etagKeys: [String] = []

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
        etagKeys.append(etag)
        UserDefaults.standard.set(etag, forKey: urlString)
    }

    static func etag(urlString: String) -> String? {
        return UserDefaults.standard.string(forKey: urlString)
    }

    static func removeAllEtags() {
        etagKeys.forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
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
    static func save(isForeground: Bool) {
        UserDefaults.standard.set(isForeground, forKey: isForegroundKey)
    }

    static func isForeground() -> Bool {
        return UserDefaults.standard.bool(forKey: isForegroundKey)
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
