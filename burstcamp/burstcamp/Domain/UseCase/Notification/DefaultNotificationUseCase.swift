//
//  DefaultNotificationUseCase.swift
//  burstcamp
//
//  Created by neuli on 2023/01/31.
//

import Foundation
import UserNotifications

final class DefaultNotificationUseCase: NotificationUseCase {

    // MARK: - Properties

    private let notificationRepository: NotificationRepository

    // MARK: - Initializer

    init (notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }

    // MARK: - Methods

    func didReceiveNotification(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        guard let feedUUID = userInfo[NotificationKey.feedUUID] as? String else { return }
        notificationRepository.saveToUserDefaults(notificationFeedUUID: feedUUID)
        NotificationCenter.default.post(name: .Push, object: nil, userInfo: userInfo)
    }

    func saveIfDifferentFromTheStoredToken(fcmToken: String?) async throws {
        let userUUID = UserManager.shared.user.userUUID
        if let fcmToken = fcmToken,
           let savedFcmToken = notificationRepository.fcmTokenInUserDefaults(),
           fcmToken != savedFcmToken {
            notificationRepository.saveToUserDefaults(fcmToken: fcmToken)
            Task {
                try await notificationRepository.saveFCMTokenToFirestore(fcmToken, to: userUUID)
            }
        }
    }

    func refresh(fcmToken: String?) async throws {
        let userUUID = UserManager.shared.user.userUUID
        if let fcmToken = fcmToken {
            notificationRepository.saveToUserDefaults(fcmToken: fcmToken)
            if !userUUID.isEmpty {
                try await notificationRepository.saveFCMTokenToFirestore(fcmToken, to: userUUID)
            }
        }
    }
}
