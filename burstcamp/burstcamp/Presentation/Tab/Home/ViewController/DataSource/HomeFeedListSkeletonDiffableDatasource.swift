//
//  HomeFeedListSkeletonDiffableDatasource.swift
//  burstcamp
//
//  Created by youtak on 2023/01/26.
//

import UIKit

import SkeletonView

final class HomeFeedListSkeletonDiffableDatasource<Section: Hashable, Item: Hashable>:
    UICollectionViewDiffableDataSource<Section, Item> {
    override init(
        collectionView: UICollectionView,
        cellProvider: @escaping UICollectionViewDiffableDataSource<Section, Item>.CellProvider
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
}

extension HomeFeedListSkeletonDiffableDatasource: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        guard let feedCellType = FeedCellType(index: indexPath.section) else { fatalError("Reusable Identifier 에러") }
        switch feedCellType {
        case .recommend:
            return RecommendFeedCell.identifier
        case .normal:
            return NormalFeedCell.identifier
        }
    }

    // 초기 목업 데이터용
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
