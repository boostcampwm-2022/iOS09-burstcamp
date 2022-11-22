//
//  ContainCollectionView.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import UIKit

protocol ContainCollectionView {

    var collectionView: UICollectionView { get set }
}

extension ContainCollectionView {
    func collectionViewDelegate(
        viewController: UICollectionViewDelegate
    ) {
        collectionView.delegate = viewController
    }

    func collectionViewDelegate(
        viewController: UICollectionViewDelegate & UICollectionViewDataSource
    ) {
        collectionView.delegate = viewController
        collectionView.dataSource = viewController
    }

    func collectionViewScrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }
}
