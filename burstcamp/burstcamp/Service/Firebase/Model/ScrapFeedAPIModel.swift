//
//  ScrapFeedAPIModel.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Foundation

import class FirebaseFirestore.Timestamp

public struct ScrapFeedAPIModel {
    let feedUUID: String
    let title: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    let scrapCount: Int
    let scrapDate: Date
    let writerCamperID: String
    let writerDomain: String
    let writerNickname: String
    let writerOrdinalNumber: Int
    let writerProfileImageURL: String
    let writerUUID: String
    let writerBlogTitle: String
}

extension ScrapFeedAPIModel {
    public init(data: FirestoreData) {
        self.feedUUID = data["feedUUID"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        let pubDateTimeStamp = data["pubDate"] as? Timestamp ?? Timestamp()
        self.pubDate = pubDateTimeStamp.dateValue()
        self.url = data["url"] as? String ?? ""
        self.thumbnailURL = data["thumbnailURL"] as? String ?? ""
        self.content = data["content"] as? String ?? ""
        self.scrapCount = data["scrapCount"] as? Int ?? 0
        let scrapDateTimeStamp = data["scrapDate"] as? Timestamp ?? Timestamp()
        self.scrapDate = scrapDateTimeStamp.dateValue()
        self.writerCamperID = data["writerCamperID"] as? String ?? ""
        self.writerDomain = data["writerDomain"] as? String ?? ""
        self.writerNickname = data["writerNickname"] as? String ?? ""
        self.writerOrdinalNumber = data["writerOrdinalNumber"] as? Int ?? 7
        self.writerProfileImageURL = data["writerProfileImageURL"] as? String ?? ""
        self.writerUUID = data["writerUUID"] as? String ?? ""
        self.writerBlogTitle = data["writerBlogTitle"] as? String ?? ""
    }

    public func toScrapFirestoreData() -> FirestoreData {
        return [
            "feedUUID": feedUUID,
            "title": title,
            "pubDate": pubDate,
            "scrapDate": scrapDate,
            "url": url,
            "thumbnailURL": thumbnailURL,
            "content": content,
            "scrapCount": scrapCount,
            "writerCamperID": writerCamperID,
            "writerDomain": writerDomain,
            "writerNickname": writerNickname,
            "writerOrdinalNumber": writerOrdinalNumber,
            "writerProfileImageURL": writerProfileImageURL,
            "writerUUID": writerUUID,
            "writerBlogTitle": writerBlogTitle
        ]
    }
}
