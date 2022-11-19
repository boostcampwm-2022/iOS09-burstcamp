//
//  HomeView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/19.
//

import UIKit

import SnapKit

final class HomeView: UIView {

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
        addSubview(defaultFeedCollectionView)
        defaultFeedCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
