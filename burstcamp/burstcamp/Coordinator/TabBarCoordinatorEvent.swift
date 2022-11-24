//
//  TabBarCoordinatorEvent.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import Foundation

enum TabBarCoordinatorEvent {

    // 마이페이지
    case moveToMyPageEditScreen
    case moveToOpenSourceScreen
    // TODO: 탈퇴
    case moveToAuthFlow

    case moveMyPageEditScreenToBackScreen(toastMessage: String = "")
}
