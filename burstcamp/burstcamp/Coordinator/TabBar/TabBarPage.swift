//
//  TabBarPage.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import Foundation

enum TabBarPage: Int {
    case home
    case scrapPage
    case myPage
}

extension TabBarPage {
    init?(index: Int) {
        self.init(rawValue: index)
    }

    var pageTitle: String {
        switch self {
        case .home: return "홈"
        case .scrapPage: return "모아보기"
        case .myPage: return "마이페이지"
        }
    }

    var pageIconTitle: String {
        switch self {
        case .home: return "house"
        case .scrapPage: return "bookmark"
        case .myPage: return "person.circle"
        }
    }

    var index: Int {
        return self.rawValue
    }
}
