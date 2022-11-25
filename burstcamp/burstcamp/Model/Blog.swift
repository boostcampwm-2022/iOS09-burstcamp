//
//  Blog.swift
//  burstcamp
//
//  Created by neuli on 2022/11/24.
//

import Foundation

struct Blog: Codable {
    let blogUUID: String
    let userUUID: String
    let url: String
    let rssURL: String
    let title: String
}
