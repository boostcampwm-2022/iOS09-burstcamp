//
//  HomeFireStore.swift
//  burstcamp
//
//  Created by youtak on 2022/11/29.
//

import Foundation

import FirebaseFirestore

final class HomeFireStore {
    func fetchFeed() {
        let database = Firestore.firestore()
        let feeds = database.collection("Feed").order(by: "pubDate",descending: true).limit(to: 20)
        feeds.getDocuments { querySnapShot, error in
            if let querySnapShot = querySnapShot {
                for document in querySnapShot.documents {
                    print(document.data())
                }
            } else {
                print(error)
            }
        }
    }
}
