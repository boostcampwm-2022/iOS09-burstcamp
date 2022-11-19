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

    func requestGithubAccessToken(code: String) -> String? {
//        guard let githubAPIKey = githubAPIKey,
//              let url = URL(string: baseURL + "/access_token")
//        else { return nil }
//
//        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
//
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: githubAPIKey.clientID),
//            URLQueryItem(name: "client_secret", value: githubAPIKey.clientSecret),
//            URLQueryItem(name: "code", value: code)
//        ]
//
//        guard let urlWithParam = urlComponents.url else { return nil }
//
//        let (data, response) = try await URLSession.shared.data(from: urlWithParam)
//
//        print(data)

        //TODO: accessToken 요청, Network Manager 필요

        return ""
    }
}
