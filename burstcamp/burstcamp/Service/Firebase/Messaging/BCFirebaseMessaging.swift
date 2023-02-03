//
//  BCFirebaseMessaging.swift
//  burstcamp
//
//  Created by youtak on 2023/02/03.
//

import Foundation

import Firebase

protocol BCFirebaseMessagingDelegate: AnyObject {
    func configureMessaging(token: String?)
    func refreshToken(token: String?)
}

final class BCFirebaseMessaging: NSObject, MessagingDelegate {

    private let messaging: Messaging
    weak var delegate: BCFirebaseMessagingDelegate?

    init(messaging: Messaging = Messaging.messaging()) {
        self.messaging = messaging
    }

    func saveApnsToken(apnsToken: Data) {
        messaging.apnsToken = apnsToken
    }

    func configureMessaging() throws {
        messaging.delegate = self
        Task { [weak self] in
            do {
                let token = try await self?.messaging.token()
                self?.delegate?.configureMessaging(token: token)
            } catch {
                debugPrint("BCFirebaseMessaging - configureMessaging 에러")
                throw BCFirebaseMessagingError.configureMessaging
            }
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            delegate?.refreshToken(token: fcmToken)
        }
    }
}

enum BCFirebaseMessagingError: Error {
    case configureMessaging
    case refreshToken
}
