//
//  TabCoordinator.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

enum TabBarPage {
    case home
    case bookmark
    case myPage

    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .bookmark
        case 2: self = .myPage
        default: return nil
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

protocol TabCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}
