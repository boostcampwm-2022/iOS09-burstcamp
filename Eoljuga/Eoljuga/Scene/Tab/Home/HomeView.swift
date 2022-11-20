//
//  HomeView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import UIKit

import SnapKit

final class HomeView: UIView {

    lazy var feedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.register(
            RecommendFeedHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecommendFeedHeader.identifier
        )
        $0.register(
            RecommendFeedCell.self,
            forCellWithReuseIdentifier: RecommendFeedCell.identifier
        )
        $0.register(
            NormalFeedCell.self,
            forCellWithReuseIdentifier: NormalFeedCell.identifier
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(feedCollectionView)
        feedCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func createLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _
            -> NSCollectionLayoutSection? in

            guard let feedCellType = FeedCellType(index: sectionIndex)
            else { return nil }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupWidth = self.groupWidth(feedCellType: feedCellType)
            let groupHeight = self.groupHeight(feedCellType: feedCellType)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: groupWidth,
                heightDimension: groupHeight
            )
            let columns = feedCellType.columnCount
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: columns
            )
            let margin = Constant.Cell.recommendMargin.cgFloat
            group.contentInsets = NSDirectionalEdgeInsets(
                top: margin,
                leading: margin,
                bottom: margin,
                trailing: margin
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: .zero,
                leading: .zero,
                bottom: Constant.space48.cgFloat,
                trailing: .zero
            )
            section.orthogonalScrollingBehavior = self.orthogonalMode(feedCellType: feedCellType)
            section.boundarySupplementaryItems = self.sectionHeader(feedCellType: feedCellType)
            return section
        }

        return layout
    }

    private func groupWidth(feedCellType: FeedCellType) -> NSCollectionLayoutDimension {
        switch feedCellType {
        case .recommend:
            let width = Constant.Cell.recommendWidth + Constant.Cell.recommendMargin * 2
            return NSCollectionLayoutDimension.absolute(width.cgFloat)
        case .normal:
            return NSCollectionLayoutDimension.fractionalWidth(1.0)
        }
    }

    private func groupHeight(feedCellType: FeedCellType) -> NSCollectionLayoutDimension {
        switch feedCellType {
        case .recommend:
            let height = Constant.Cell.recommendHeight + Constant.Cell.recommendMargin * 2
            return NSCollectionLayoutDimension.absolute(height.cgFloat)
        case .normal:
            return NSCollectionLayoutDimension.absolute(Constant.Cell.normalHeight.cgFloat)
        }
    }

    private func orthogonalMode(feedCellType: FeedCellType)
    -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch feedCellType {
        case .recommend: return .continuous
        case .normal: return .none
        }
    }

    private func sectionHeader(feedCellType: FeedCellType)
    -> [NSCollectionLayoutBoundarySupplementaryItem] {
        switch feedCellType {
        case .recommend:
            let padding = Constant.Padding.horizontal.cgFloat
            let headerHeight = 80 + padding * 2
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(headerHeight)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(
                top: padding,
                leading: padding,
                bottom: padding,
                trailing: padding
            )
            return [header]
        case .normal:
            return []
        }
    }
}
