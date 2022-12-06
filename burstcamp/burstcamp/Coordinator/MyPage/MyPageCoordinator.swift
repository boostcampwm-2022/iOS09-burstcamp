//
//  MyPageCoordinator.swift
//  burstcamp
//
//  Created by youtak on 2022/12/06.
//

import Foundation

protocol MyPageCoordinatorProtocol: Coordinator {
    func moveToMyPageEditScreen(myPageViewController: MyPageViewController)
    func moveToOpenSourceScreen()
    func moveToAuthFlow()
    func moveMyPageEditScreenToBackScreen(
        myPageViewController: MyPageViewController,
        toastMessage: String
    )
}
