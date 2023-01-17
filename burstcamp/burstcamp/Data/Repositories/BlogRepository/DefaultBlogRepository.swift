//
//  DefaultBlogRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultBlogRepository: BlogRepository {

    private let bcFirebaseFunctionService: BCFirebaseFunctionService

    init(bcFirebaseFunctionService: BCFirebaseFunctionService) {
        self.bcFirebaseFunctionService = bcFirebaseFunctionService
    }

    func checkBlogTitle(link: String) async throws -> String {
        return try await bcFirebaseFunctionService.getBlogTitle(link: link)
    }

    func isValidateLink(_ link: String) -> Bool {
        return Validator.validate(blogLink: link)
    }
}
