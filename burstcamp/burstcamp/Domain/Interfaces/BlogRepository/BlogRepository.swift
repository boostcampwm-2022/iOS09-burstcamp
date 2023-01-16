//
//  BlogRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol BlogRepository {
    func checkBlogTitle(link: String) async throws -> String
    func isValidateLink(_ link: String) -> Bool
}
