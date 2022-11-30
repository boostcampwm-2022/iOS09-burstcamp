//
//  Notification+Name.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Foundation

extension Notification.Name {
    static let Push = Notification.Name(rawValue: "push")
}

enum NotificationKey {
    static let feedUUID = "feedUUID"
}
