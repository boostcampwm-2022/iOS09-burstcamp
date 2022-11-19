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
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.register(DefaultFeedCell.self, forCellWithReuseIdentifier: DefaultFeedCell.identifier)
    }

    lazy var defaultFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.zero.cgFloat
        layout.sectionInset = .zero
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.register(DefaultFeedCell.self, forCellWithReuseIdentifier: DefaultFeedCell.identifier)
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

//        addSubview(defaultFeedCollectionView)
//        defaultFeedCollectionView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }

    private func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(300),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}
