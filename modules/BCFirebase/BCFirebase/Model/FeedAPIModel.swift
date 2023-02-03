//
//  FeedAPIModel.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import Foundation

import class FirebaseFirestore.Timestamp

public struct FeedAPIModel {
    public let feedUUID: String
    public let title: String
    public let pubDate: Date
    public let url: String
    public let thumbnailURL: String
    public let content: String
    public let scrapCount: Int
    public let writerCamperID: String
    public let writerDomain: String
    public let writerNickname: String
    public let writerOrdinalNumber: Int
    public let writerProfileImageURL: String
    public let writerUUID: String
    public let writerBlogTitle: String
    
    public init(feedUUID: String,
         title: String,
         pubDate: Date,
         url: String,
         thumbnailURL: String,
         content: String,
         scrapCount: Int,
         writerCamperID: String,
         writerDomain: String,
         writerNickname: String,
         writerOrdinalNumber: Int,
         writerProfileImageURL: String,
         writerUUID: String,
         writerBlogTitle: String
    ) {
        self.feedUUID = feedUUID
        self.title = title
        self.pubDate = pubDate
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.content = content
        self.scrapCount = scrapCount
        self.writerCamperID = writerCamperID
        self.writerDomain = writerDomain
        self.writerNickname = writerNickname
        self.writerOrdinalNumber = writerOrdinalNumber
        self.writerProfileImageURL = writerProfileImageURL
        self.writerUUID = writerUUID
        self.writerBlogTitle = writerBlogTitle
    }
}

public extension FeedAPIModel {
    init(data: FirestoreData) {
        self.feedUUID = data["feedUUID"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        let timeStampDate = data["pubDate"] as? Timestamp ?? Timestamp()
        self.pubDate = timeStampDate.dateValue()
        self.url = data["url"] as? String ?? ""
        self.thumbnailURL = data["thumbnailURL"] as? String ?? ""
        self.content = data["content"] as? String ?? ""
        self.scrapCount = data["scrapCount"] as? Int ?? 0
        self.writerCamperID = data["writerCamperID"] as? String ?? ""
        self.writerDomain = data["writerDomain"] as? String ?? ""
        self.writerNickname = data["writerNickname"] as? String ?? ""
        self.writerOrdinalNumber = data["writerOrdinalNumber"] as? Int ?? 7
        self.writerProfileImageURL = data["writerProfileImageURL"] as? String ?? ""
        self.writerUUID = data["writerUUID"] as? String ?? ""
        self.writerBlogTitle = data["writerBlogTitle"] as? String ?? ""
    }

    func toScrapFirestoreData(scrapDate: Date) -> FirestoreData {
        return [
            "feedUUID": feedUUID,
            "title": title,
            "pubDate": pubDate,
            "scrapDate": Timestamp(date: scrapDate),
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
