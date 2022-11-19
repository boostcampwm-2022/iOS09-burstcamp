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
            withReuseIdentifier: RecommendFeedCell.identifier,
            for: indexPath
        ) as? RecommendFeedCell
        else {
            return UICollectionViewCell()
        }

        return cell
    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        let width = view.frame.width - Constant.Padding.horizontal.cgFloat * 2
//        return CGSize(width: width, height: 150)
//    }
}
