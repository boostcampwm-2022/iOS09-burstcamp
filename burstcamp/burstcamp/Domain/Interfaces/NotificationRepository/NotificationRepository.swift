//
//  NotificationRepository.swift
//  burstcamp
//
//  Created by neuli on 2023/01/31.
//

import Foundation

protocol NotificationRepository {
    func saveToUserDefaults(fcmToken: String)
    func fcmTokenInUserDefaults() -> String?
    func saveFCMTokenToFirestore(_ fcmToken: String, to userUUID: String) async throws

    func saveToUserDefaults(notificationFeedUUID: String)
    func notificationFeedUUIDInUserDefaults() -> String?
    func removeNotificationFeedUUID()
}
