//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct Feed: Codable {
    let feedUUID: String
    let writerUUID: String
    let feedTitle: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
}
