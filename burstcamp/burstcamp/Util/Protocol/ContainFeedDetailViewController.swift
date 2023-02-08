//
//  ContainFeedDetailViewController.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Combine
import Foundation

protocol ContainFeedDetailViewController {
    func configure(
        scrapUpdatePublisher: AnyPublisher<Feed, Never>,
        deletePublisher: AnyPublisher<Feed, Never>
    )
}
