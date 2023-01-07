//
//  FeedAPIModel.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import Foundation

import class FirebaseFirestore.Timestamp

struct FeedAPIModel {
    let feedUUID: String
    let title: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    let writerCamperID: String
    let writerDomain: String
    let writerNickname: String
    let writerOrdinalNumber: Int
    let writerProfileImageURL: String
    let writerUUID: String
}

extension FeedAPIModel {
    init(data: [String: Any]) {
        self.feedUUID = data["feedUUID"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        let timeStampDate = data["pubDate"] as? Timestamp ?? Timestamp()
        self.pubDate = timeStampDate.dateValue()
        self.url = data["url"] as? String ?? ""
        self.thumbnailURL = data["thumbnailURL"] as? String ?? ""
        self.content = data["content"] as? String ?? ""
        self.writerCamperID = data["writerCamperID"] as? String ?? ""
        self.writerDomain = data["writerDomain"] as? String ?? ""
        self.writerNickname = data["writerNickname"] as? String ?? ""
        self.writerOrdinalNumber = data["writerOrdinalNumber"] as? Int ?? 7
        self.writerProfileImageURL = data["writerProfileImageURL"] as? String ?? ""
        self.writerUUID = data["writerUUID"] as? String ?? ""
    }
}
