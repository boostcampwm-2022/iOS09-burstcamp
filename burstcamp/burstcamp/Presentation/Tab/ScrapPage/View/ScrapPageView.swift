//
//  ScrapView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import UIKit

class ScrapPageView: UIView, ContainCollectionView {

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.zero.cgFloat
        layout.sectionInset = .zero
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
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
        configureScrapView()
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureScrapView() {
        backgroundColor = .background
    }
}
