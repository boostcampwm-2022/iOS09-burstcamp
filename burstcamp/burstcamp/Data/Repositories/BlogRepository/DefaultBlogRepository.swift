//
//  DefaultBlogRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultBlogRepository: BlogRepository {
    func checkBlogTitle() async throws -> String {
        return "BLog다 "
    }
}
