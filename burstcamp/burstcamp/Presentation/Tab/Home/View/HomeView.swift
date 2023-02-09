//
//  HomeView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import UIKit

import SnapKit

final class HomeView: UIView, ContainCollectionView {

    private var recommendFeedCount = 3

    lazy var collectionView = UICollectionView(
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
        configureRefreshControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureHomeView()
        addSubview(collectionView)
        configureCollectionView()
    }

    private func configureHomeView() {
        backgroundColor = .background
    }

    private func configureCollectionView() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
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
            item.contentInsets = self.setItemInset(feedCellType: feedCellType)

            let groupWidth = self.setGroupWidth(feedCellType: feedCellType)
            let groupHeight = self.setGroupHeight(feedCellType: feedCellType)
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

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: .zero,
                leading: .zero,
                bottom: Constant.space32.cgFloat,
                trailing: .zero
            )
            section.orthogonalScrollingBehavior = self.orthogonalMode(feedCellType: feedCellType)
            section.boundarySupplementaryItems = self.sectionHeader(feedCellType: feedCellType)
            section.visibleItemsInvalidationHandler = { [weak self] item, offset, environment in
                guard let self = self else { return }
                self.carousel(item: item, offset: offset, environment: environment)
            }
            return section
        }

        return layout
    }

    private func carousel(
        item: [NSCollectionLayoutVisibleItem],
        offset: CGPoint,
        environment: NSCollectionLayoutEnvironment
    ) {
        guard let itemSize = item.first?.frame.width,
              let section = item.first?.indexPath.section,
              section == 0
        else { return }
        let itemInset = Constant.Cell.recommendMargin.cgFloat
        let contentSize = itemSize + itemInset * 2
        let screenWidth = environment.container.contentSize.width
        let startOffsetX = -((screenWidth - contentSize) / 2)

        let contentCount = recommendFeedCount
        let leftLimitOffsetX = startOffsetX + contentSize
        let rightLimitOffsetX = startOffsetX + contentSize * (2 * contentCount + 1).cgFloat
        let currentOffsetX = offset.x

        if currentOffsetX <= leftLimitOffsetX || currentOffsetX >= rightLimitOffsetX {
            scrollToCenter()
        }
    }

    private func scrollToCenter() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.scrollToItem(
                at: IndexPath(row: self.recommendFeedCount + 1, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }

    private func setItemInset(feedCellType: FeedCellType) -> NSDirectionalEdgeInsets {
        switch feedCellType {
        case .recommend:
            let itemInset = Constant.Cell.recommendMargin.cgFloat
            return NSDirectionalEdgeInsets(
                top: itemInset,
                leading: itemInset,
                bottom: itemInset,
                trailing: itemInset
            )
        case .normal:
            let itemInset = Constant.Padding.horizontal.cgFloat
            return NSDirectionalEdgeInsets(
                top: 0,
                leading: itemInset,
                bottom: 0,
                trailing: itemInset
            )
        }
    }

    private func setGroupWidth(feedCellType: FeedCellType) -> NSCollectionLayoutDimension {
        switch feedCellType {
        case .recommend:
            return NSCollectionLayoutDimension.fractionalWidth(0.85)
        case .normal:
            return NSCollectionLayoutDimension.fractionalWidth(1.0)
        }
    }

    private func setGroupHeight(feedCellType: FeedCellType) -> NSCollectionLayoutDimension {
        switch feedCellType {
        case .recommend:
            return NSCollectionLayoutDimension.fractionalWidth(0.5)
        case .normal:
            return NSCollectionLayoutDimension.absolute(Constant.Cell.normalHeight.cgFloat)
        }
    }

    private func orthogonalMode(feedCellType: FeedCellType)
    -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch feedCellType {
        case .recommend: return .groupPagingCentered
        case .normal: return .none
        }
    }

    private func sectionHeader(feedCellType: FeedCellType)
    -> [NSCollectionLayoutBoundarySupplementaryItem] {
        switch feedCellType {
        case .recommend:
            let horizontalPadding = Constant.space32.cgFloat
            let verticalPadding = Constant.space16.cgFloat
            let headerHeight = 80 + verticalPadding * 2
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
                top: 0,
                leading: horizontalPadding,
                bottom: 0,
                trailing: horizontalPadding
            )
            return [header]
        case .normal:
            return []
        }
    }

    private func setRecommendFeedCount(_ count: Int) {
        recommendFeedCount = count
    }

    private func updateHeader() {
        if let recommendFeedHeader = collectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader
        ).first as? RecommendFeedHeader {
            recommendFeedHeader.updateTitleLabel()
        }
    }
}

extension HomeView {
    func updateRecommendSection(recommendFeedCount: Int) {
        setRecommendFeedCount(recommendFeedCount)
        updateHeader()
    }
}
