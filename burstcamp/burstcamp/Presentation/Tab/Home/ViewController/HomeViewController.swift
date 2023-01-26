//
//  HomeViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

import SkeletonView
import SnapKit
import Then

final class HomeViewController: UIViewController {

    private var homeView: HomeView {
        guard let view = view as? HomeView else {
            return HomeView()
        }
        return view
    }
    private var loadingView: LoadingView!

    private var dataSource: UICollectionViewDiffableDataSource<FeedCellType, DiffableFeed>!
    private var collectionViewSnapShot: NSDiffableDataSourceSnapshot<FeedCellType, DiffableFeed>!

    private var viewModel: HomeViewModel
    private var cancelBag = Set<AnyCancellable>()
    let coordinatorPublisher = PassthroughSubject<HomeCoordinatorEvent, Never>()
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
        configureDataSource()
        bind()
        configureAttributes()
        configurePushNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func configureUI() {}

    private func configureAttributes() {
        homeView.collectionView.isSkeletonable = true
        homeView.collectionView.showSkeleton(usingColor: .systemGray5)
    }

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

    private func paginateFeed() {
        paginationPublisher.send(Void())
    }
}

// MARK: Bind

extension HomeViewController {
    private func bind() {
        guard let refreshControl = homeView.collectionView.refreshControl
        else { return }

        let viewDidLoadJust = Just(Void()).eraseToAnyPublisher()

        let input = HomeViewModel.Input(
            viewDidLoad: viewDidLoadJust,
            viewDidRefresh: refreshControl.refreshPublisher,
            pagination: paginationPublisher.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.recentFeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] homeFeedList in
                self?.homeView.hideSkeleton()
                self?.reloadHomeFeedList(homeFeedList: homeFeedList)
            }
            .store(in: &cancelBag)

        output.moreFeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] normalFeed in
                self?.reloadHomeFeedList(additional: normalFeed)
            }
            .store(in: &cancelBag)

        output.showAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlert(message: error.localizedDescription)
            }
            .store(in: &cancelBag)

        output.hideIndicator
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.homeView.endCollectionViewRefreshing()
            }
            .store(in: &cancelBag)

        output.showToast
            .receive(on: DispatchQueue.main)
            .sink { message in
                self.showToastMessage(text: message)
            }
            .store(in: &cancelBag)
    }

    private func bindNormalFeedCell(_ cell: NormalFeedCell, index: Int, feedUUID: String) {

        let scrapButtonDidTap = cell.getButtonTapPublisher()
            .map { _  in
                cell.footerView.scrapButton.isEnabled = false
                return index
            }
            .eraseToAnyPublisher()

        let cellInput = HomeViewModel.CellInput(
            scrapButtonDidTap: scrapButtonDidTap
        )

        let output = viewModel.transform(cellInput: cellInput, cellCancelBag: &cell.cancelBag)

        output.scrapSuccess
            .receive(on: DispatchQueue.main)
            .sink { updatedFeed in
                if feedUUID == updatedFeed.feedUUID {
                    cell.footerView.countLabel.text = updatedFeed.scrapCount.description
                    cell.footerView.scrapButton.isOn = updatedFeed.isScraped
                    cell.footerView.scrapButton.isEnabled = true
                }
            }
            .store(in: &cell.cancelBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let feedCellType = FeedCellType(index: indexPath.section)

        switch feedCellType {
        case .recommend:
            let recommendFeed = viewModel.recommendFeedData[indexPath.row]
            guard let url = URL(string: recommendFeed.url) else {
                showAlert(message: "블로그 URL이 올바르지 않습니다.")
                return
            }
            coordinatorPublisher.send(.moveToBlogSafari(url: url))
            return
        case .normal:
            let feed = viewModel.normalFeedData[indexPath.row]
            coordinatorPublisher.send(.moveToFeedDetail(feed: feed))
        case .none:
            showAlert(message: "피드 데이터가 올바르지 않습니다.")
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isOverTarget() {
            paginateFeed()
        }
    }
}

// MARK: - DataSource
extension HomeViewController {
    private func configureDataSource() {
        dataSource = getHomeFeedListDataSource()

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            return self?.dataSourceSupplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }

        initSnapShot()
    }

    private func getHomeFeedListDataSource() -> UICollectionViewDiffableDataSource<FeedCellType, DiffableFeed> {

        let recommendFeedCellRegistration = UICollectionView.CellRegistration<RecommendFeedCell, Feed> { cell, _, feed in
            cell.updateFeedCell(with: feed)
        }

        let normalFeedCellRegistration = UICollectionView.CellRegistration<NormalFeedCell, Feed> { cell, indexPath, feed in
            self.bindNormalFeedCell(cell, index: indexPath.row, feedUUID: feed.feedUUID)
            cell.updateFeedCell(with: feed)
        }

        return HomeFeedListSkeletonDiffableDatasource(
            collectionView: homeView.collectionView,
            cellProvider: { collectionView, indexPath, diffableFeed in
                switch diffableFeed {
                case .recommend(let feed):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: recommendFeedCellRegistration,
                        for: indexPath,
                        item: feed
                    )
                case .normal(let feed):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: normalFeedCellRegistration,
                        for: indexPath,
                        item: feed
                    )
                }
            })
    }

    private func dataSourceSupplementary(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        switch  FeedCellType(index: indexPath.section) {
        case .recommend:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: RecommendFeedHeader.identifier,
                for: indexPath
            ) as? RecommendFeedHeader else {
                return UICollectionReusableView()
            }

            return header
        default:
            return nil
        }
    }
}

// MARK: Snapshot

extension HomeViewController {
    private func initSnapShot() {
        collectionViewSnapShot = NSDiffableDataSourceSnapshot<FeedCellType, DiffableFeed>()
        collectionViewSnapShot.appendSections([.recommend, .normal])
        dataSource.apply(collectionViewSnapShot, animatingDifferences: false)
    }

    private func reloadHomeFeedList(homeFeedList: HomeFeedList) {
        let previousRecommendFeedData = collectionViewSnapShot.itemIdentifiers(inSection: .recommend)
        let previousNormalFeedData = collectionViewSnapShot.itemIdentifiers(inSection: .normal)
        collectionViewSnapShot.deleteItems(previousRecommendFeedData)
        collectionViewSnapShot.deleteItems(previousNormalFeedData)

        snapShotAppend(feedList: homeFeedList.recommendFeed, toSection: .recommend)
        snapShotAppend(feedList: homeFeedList.normalFeed, toSection: .normal)
        dataSource.apply(collectionViewSnapShot, animatingDifferences: false)
    }

    private func reloadHomeFeedList(additional normalFeedList: [Feed]) {
        snapShotAppend(feedList: normalFeedList, toSection: .normal)
        dataSource.apply(collectionViewSnapShot, animatingDifferences: false)
    }

    private func reloadNormalFeedSection(normalFeedList: [Feed]) {
        let previousNormalFeedData = collectionViewSnapShot.itemIdentifiers(inSection: .normal)
        collectionViewSnapShot.deleteItems(previousNormalFeedData)

        snapShotAppend(feedList: normalFeedList, toSection: .normal)
        dataSource.apply(collectionViewSnapShot, animatingDifferences: false)
    }

    private func snapShotAppend(feedList: [Feed], toSection: FeedCellType) {
        if toSection == .normal {
            feedList.forEach { collectionViewSnapShot.appendItems([DiffableFeed.normal($0)], toSection: .normal) }
        } else if toSection == .recommend {
            feedList.forEach { collectionViewSnapShot.appendItems([DiffableFeed.recommend($0)], toSection: .recommend) }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension HomeViewController: UNUserNotificationCenterDelegate {
    private func configurePushNotification() {
        let application = UIApplication.shared

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions
        ) { isPushOn, _ in
            let userUUID = UserManager.shared.user.userUUID
            if !userUUID.isEmpty {
                // TODO: push 상태 업데이트
//                FirestoreUser.update(userUUID: userUUID, isPushOn: isPushOn)
            }
        }
        application.registerForRemoteNotifications()
    }
}

extension HomeViewController: ContainFeedDetailViewController {
    func configure(scrapUpdatePublisher: AnyPublisher<Feed, Never>) {
        scrapUpdatePublisher
            .sink { [weak self] feed in
                guard let normalFeedList = self?.viewModel.updateNormalFeed(feed) else {
                    self?.showAlert(message: "피드 업데이트 중 에러가 발생했습니다.")
                    return
                }
                self?.reloadNormalFeedSection(normalFeedList: normalFeedList)
            }
            .store(in: &cancelBag)
    }
}
