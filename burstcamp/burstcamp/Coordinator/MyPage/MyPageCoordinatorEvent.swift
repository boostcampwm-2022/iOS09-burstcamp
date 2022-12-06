//
//  MyPageCoordinatorEvent.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import Foundation

enum MyPageCoordinatorEvent {
    case moveToMyPageEditScreen
    case moveToOpenSourceScreen
    case moveToAuthFlow

    case moveMyPageEditScreenToBackScreen(toastMessage: String)
}
