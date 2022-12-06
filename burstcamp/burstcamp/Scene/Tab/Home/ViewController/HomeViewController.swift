//
//  HomeViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
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
    private var cancelBag = Set<AnyCancellable>()
    private let paginationPublisher = PassthroughSubject<Void, Never>()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        collectionViewDelegate()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func configureUI() {}

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "홈"
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
        guard let refreshControl = homeView.collectionView.refreshControl
        else { return }

        let viewDidLoadJust = Just(Void()).eraseToAnyPublisher()

        let input = HomeViewModel.Input(
            viewDidLoad: viewDidLoadJust,
            viewRefresh: refreshControl.isRefreshPublisher,
            pagination: paginationPublisher.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.fetchResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchResult in
                switch fetchResult {
                case .fetchSuccess:
                    self?.homeView.endCollectionViewRefreshing()
                    self?.homeView.collectionView.reloadData()
                case .fetchFail(let error):
                    print(error)
                }
            }
            .store(in: &cancelBag)

        output.cellUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.reloadCollectionView(indexPath: indexPath)
            }
            .store(in: &cancelBag)
    }

    func reloadCollectionView(indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            homeView.collectionView.reloadItems(at: [indexPath])
        }
    }

    private func paginateFeed() {
        paginationPublisher.send(Void())
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
        let feedCellType = FeedCellType(index: section)
        switch feedCellType {
        case .recommend: return viewModel.recommendFeedData.count * 3
        case .normal: return viewModel.normalFeedData.count
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
            let index = indexPath.row % 3
            let feed = viewModel.recommendFeedData[index]
            cell.updateView(with: feed)
            return cell
        case .normal:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NormalFeedCell.identifier,
                for: indexPath
            ) as? NormalFeedCell
            else {
                return UICollectionViewCell()
            }
            let index = indexPath.row
            let feed = viewModel.normalFeedData[index]
            let cellViewModel = viewModel.dequeueCellViewModel(at: index)
            cell.configure(with: cellViewModel)
            cell.updateFeedCell(with: feed)

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

    // FeedDetail Test용
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feed = viewModel.normalFeedData[indexPath.row]
        let feedDetailViewModel = FeedDetailViewModel(feed: feed)
        let feedScrapViewModel = FeedScrapViewModel(feedUUID: feed.feedUUID)
        let viewController = FeedDetailViewController(
            feedDetailViewModel: feedDetailViewModel,
            feedScrapViewModel: feedScrapViewModel
        )
        navigationController?.pushViewController(viewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isOverTarget() {
            paginateFeed()
        }
    }
}
