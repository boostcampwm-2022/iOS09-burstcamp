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
            return HomeView()
        }
        return view
    }

    private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionViewDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func configureUI() {}

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Hello, 얼죽아"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollToTop))
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
    }

    private func collectionViewDelegate() {
        homeView.collectionViewDelegate(viewController: self)
    }

    @objc private func scrollToTop() {
        homeView.collectionViewScrollToTop()
    }
    private func bind() {
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        case .normal: return 100
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
