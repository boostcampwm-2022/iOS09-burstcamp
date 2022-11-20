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

    private var homeView: HomeView {
        guard let view = view as? HomeView else {
            return HomeView(frame: view.frame)
        }
        return view
    }

    override func loadView() {
        super.loadView()
        view = HomeView(frame: view.frame)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionViewDelegate()
    }

    private func configureUI() {
        configureNavigationBar()
        configureViewController()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Hello, 얼죽아"
    }

    private func configureViewController() {
        view.backgroundColor = .white
    }

    private func collectionViewDelegate() {
        homeView.feedCollectionView.delegate = self
        homeView.feedCollectionView.dataSource = self
    }

    private func bind() {
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FeedCellType.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        // TODO: ViewModel의 data count로 바꿔줘야함
        let feedCellType = FeedCellType(index: section)
        switch feedCellType {
        case .recommend: return 3
        case .normal: return 5
        case .none: return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let feedCellType = FeedCellType(index: indexPath.section)

        switch feedCellType {
        case .recommend:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendFeedCell.identifier,
                for: indexPath
            ) as? RecommendFeedCell
            else {
                return UICollectionViewCell()
            }

            return cell
        case .normal:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NormalFeedCell.identifier,
                for: indexPath
            ) as? NormalFeedCell
            else {
                return UICollectionViewCell()
            }

            return cell
        case .none:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader
            && FeedCellType(index: indexPath.section) == .recommend {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: RecommendFeedHeader.identifier,
                for: indexPath
            ) as? RecommendFeedHeader else {
                return UICollectionReusableView()
            }

            return header
        }
        return UICollectionReusableView()
    }
}
