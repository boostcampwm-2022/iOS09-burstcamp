//
//  DefaultNotificationRepository.swift
//  burstcamp
//
//  Created by neuli on 2023/01/31.
//

import Foundation

import BCFirebase

final class DefaultNotificationRepository: NotificationRepository {

    // MARK: - Properties

    private let userDefaultsService: UserDefaultsService
    private let bcFirestoreService: BCFirestoreServiceProtocol
    private let fcmTokenKey = UserDefaultsKey.fcmTokenKey
    private let notificationFeedUUIDKey = UserDefaultsKey.notificationFeedUUIDKey

    // MARK: Initializer

    init(
        userDefaultsService: UserDefaultsService,
        bcFirestoreService: BCFirestoreServiceProtocol
    ) {
        self.userDefaultsService = userDefaultsService
        self.bcFirestoreService = bcFirestoreService
    }

    // MARK: - Methods
    // MARK: FCMToken

    func saveToUserDefaults(fcmToken: String) {
        userDefaultsService.save(value: fcmToken, forKey: fcmTokenKey)
    }

    func fcmTokenInUserDefaults() -> String? {
        return userDefaultsService.stringValue(forKey: fcmTokenKey)
    }

    func saveFCMTokenToFirestore(_ fcmToken: String, to userUUID: String) async throws {
        do {
            return try await bcFirestoreService.saveFCMToken(fcmToken, to: userUUID)
        } catch {
            throw NotificationRepositoryError.failedToSaveFCMToken
        }
    }

    // MARK: NotificationFeedUUID

    func saveToUserDefaults(notificationFeedUUID: String) {
        userDefaultsService.save(value: notificationFeedUUID, forKey: notificationFeedUUIDKey)
    }

    func notificationFeedUUIDInUserDefaults() -> String? {
        return userDefaultsService.stringValue(forKey: notificationFeedUUIDKey)
    }

    func removeNotificationFeedUUID() {
        userDefaultsService.delete(forKey: notificationFeedUUIDKey)
    }
}
