//
//  DependencyFactoryProtocol.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol DependencyFactoryProtocol {
    func createLoginViewModel() -> LogInViewModel
    func createSignUpDomainViewModel() -> SignUpDomainViewModel
    func createSignUpCamperIDViewModel() -> SignUpCamperIDViewModel
    func createSignUpBlogViewModel() -> SignUpBlogViewModel
    func createHomeViewModel() -> HomeViewModel
    func createScrapPageViewModel() -> ScrapPageViewModel
    func createFeedDetailViewModel(feed: Feed) -> FeedDetailViewModel
    func createFeedDetailViewModel(feedUUID: String) -> FeedDetailViewModel
    func createMyPageViewModel() -> MyPageViewModel
    func createMyPageEditViewModel() -> MyPageEditViewModel
}
