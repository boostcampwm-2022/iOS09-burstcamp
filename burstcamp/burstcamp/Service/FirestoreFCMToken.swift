//
//  FirestoreFCMTokenService.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Foundation

import Firebase
import FirebaseFirestore

struct FirebaseFCMToken {
    private static let fcmTokenPath = Firestore.firestore().collection("fcmToken")

    static func save(fcmToken: String, to userUUID: String) {
        let fcmToken = FCMToken(fcmToken: fcmToken)
        let path = fcmTokenPath.document(userUUID)

        guard let dictionary = fcmToken.asDictionary
        else {
            print("데이터 dictionary 변환 실패")
            return
        }

        path.setData(dictionary) { error in
            if let error = error {
                print("파이어베이스 fcmToken 저장 실패: \(error.localizedDescription)")
                return
            }
        }
    }
}
