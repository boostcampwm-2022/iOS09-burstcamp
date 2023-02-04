//
//  BCFirebaseMessaging.swift
//  burstcamp
//
//  Created by youtak on 2023/02/03.
//

import Foundation

import Firebase

public protocol BCFirebaseMessagingDelegate: AnyObject {
    func configureMessaging(token: String?)
    func refreshToken(token: String?)
}

public final class BCFirebaseMessaging: NSObject, MessagingDelegate {

    private let messaging: Messaging
    public weak var delegate: BCFirebaseMessagingDelegate?

    public init(messaging: Messaging = Messaging.messaging()) {
        self.messaging = messaging
    }

    public func saveApnsToken(apnsToken: Data) {
        messaging.apnsToken = apnsToken
    }

    public func configureMessaging() throws {
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

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            delegate?.refreshToken(token: fcmToken)
        }
    }
}

public enum BCFirebaseMessagingError: Error {
    case configureMessaging
    case refreshToken
}
