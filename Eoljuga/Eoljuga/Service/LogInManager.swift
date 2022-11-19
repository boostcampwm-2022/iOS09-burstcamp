//
//  LogInManager.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import UIKit

final class LogInManager {

    static let shared = LogInManager()

    private init () {}

    private let baseURL: String = "https://github.com/login/oauth"

    private var githubAPIKey: Github? {
        guard let serviceInfoURL = Bundle.main.url(
            forResource: "Service-Info",
            withExtension: "plist"
        ),
              let data = try? Data(contentsOf: serviceInfoURL),
              let apiKey = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else { return nil }
        return apiKey.github
    }

    func openGithubLoginView() {
        guard let clientID = githubAPIKey?.clientID,
              let url = URL(string: baseURL + "/authorize?client_id=\(clientID)")
        else { return }

        UIApplication.shared.open(url)
    }

    func requestAccessToken(code: String) -> String? {
        guard let githubAPIKey = githubAPIKey else { return nil }
        print(code)
        // TODO: accessToken요청

        let url = baseURL + "/access_token"
        return ""
    }
}