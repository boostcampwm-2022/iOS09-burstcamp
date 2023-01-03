//
//  CoordinatorEvent.swift
//  burstcamp
//
//  Created by youtak on 2022/12/07.
//

import Foundation

enum AppCoordinatorEvent {
    case moveToAuthFlow
    case moveToTabBarFlow
}

enum AuthCoordinatorEvent {
    case moveToDomainScreen
    case moveToIDScreen
    case moveToBlogScreen
    case moveToTabBarScreen
    case showAlert(String)
    case moveToGithubLogIn
}

enum TabBarCoordinatorEvent {
    case moveToAuthFlow
}

enum HomeCoordinatorEvent {
    case moveToFeedDetail(feed: Feed)
}

enum ScrapPageCoordinatorEvent {
    case moveToFeedDetail(feed: Feed)
}

enum MyPageCoordinatorEvent {
    case moveToMyPageEditScreen
    case moveToOpenSourceScreen
    case moveToAuthFlow

    case moveMyPageEditScreenToBackScreen(toastMessage: String)
    case moveToGithubLogIn
}

enum FeedDetailCoordinatorEvent {
    case moveToBlogSafari(url: URL)
}
