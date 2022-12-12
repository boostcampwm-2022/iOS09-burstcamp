//
//  GithubLogInCoordinator.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/12.
//

import Foundation
import SafariServices

protocol GithubLogInCoordinator: Coordinator { }

extension GithubLogInCoordinator {
    func moveToGithubLogIn() {
        let urlString = "https://github.com/login/oauth/authorize"

        guard var urlComponent = URLComponents(string: urlString),
              let clientID = LogInManager.shared.githubAPIKey?.clientID
        else {
            return
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "admin:org")
        ]

        guard let url = urlComponent.url else { return }
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }
}
