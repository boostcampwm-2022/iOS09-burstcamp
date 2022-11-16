//
//  TabBarPage.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/16.
//

import Foundation

enum TabBarPage {
    case home
    case bookmark
    case myPage

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .bookmark
        case 2:
            self = .myPage
        default:
            return nil
        }
    }

    func pageTitle() -> String {
        switch self {
        case .home: return "홈"
        case .bookmark: return "모아보기"
        case .myPage: return "마이페이지"
        }
    }

    func pageIconTitle() -> String {
        switch self {
        case .home: return "house"
        case .bookmark: return "bookmark"
        case .myPage: return "person.circle"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .bookmark: return 1
        case .myPage: return 2
        }
    }
}
