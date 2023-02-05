//
//  NotificationUseCase.swift
//  burstcamp
//
//  Created by neuli on 2023/01/31.
//

import UserNotifications
import Foundation

protocol NotificationUseCase {
    func didReceiveNotification(response: UNNotificationResponse)
    func saveIfDifferentFromTheStoredToken(fcmToken: String?) async throws
    func refresh(fcmToken: String?) async throws
}
