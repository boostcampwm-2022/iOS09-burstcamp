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
        layout.minimumLineSpacing = Constant.zero.cgFloat
        layout.sectionInset = .zero
        $0.collectionViewLayout = layout
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(DefaultFeedCell.self, forCellWithReuseIdentifier: DefaultFeedCell.identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        configureNavigationBar()
        configureViewController()
        configureDefaultFeedCollectionView()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Hello, 얼죽아"
    }

    private func configureViewController() {
        view.backgroundColor = .white
    }

    private func configureDefaultFeedCollectionView() {
        view.addSubview(defaultFeedCollectionView)
        defaultFeedCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DefaultFeedCell.identifier,
            for: indexPath
        ) as? DefaultFeedCell
        else {
            return UICollectionViewCell()
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = defaultFeedCollectionView.frame.width - Constant.Padding.horizontral.cgFloat * 2
        return CGSize(width: width, height: 150)
    }
}
