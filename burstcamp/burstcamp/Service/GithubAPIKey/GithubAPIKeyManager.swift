//
//  GithubAPIKeyManager.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class GithubAPIKeyManager {
    var githubAPIKey: Github? {
        guard let serviceInfoURL = Bundle.main.url(
            forResource: "Service-Info",
            withExtension: "plist"
        ),
              let data = try? Data(contentsOf: serviceInfoURL),
              let apiKey = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else { return nil }
        return apiKey.github
    }
}
