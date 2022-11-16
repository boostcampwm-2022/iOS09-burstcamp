//
//  HomeViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {

    lazy var defaultFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        $0.collectionViewLayout = layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        configureView()
        configureDefaultFeedCollectionView()
    }

    private func configureView() {
        view.backgroundColor = .white
    }

    private func configureDefaultFeedCollectionView() {
        view.addSubview(defaultFeedCollectionView)
        defaultFeedCollectionView.backgroundColor = .orange
        defaultFeedCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
