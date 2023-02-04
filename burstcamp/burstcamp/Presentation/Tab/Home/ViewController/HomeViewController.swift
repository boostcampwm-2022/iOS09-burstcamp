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

    private var viewModel: HomeViewModel

    private var dataSource: UICollectionViewDiffableDataSource<FeedCellType, DiffableFeed>!
    private var collectionViewSnapShot: NSDiffableDataSourceSnapshot<FeedCellType, DiffableFeed>!

    let coordinatorPublisher = PassthroughSubject<HomeCoordinatorEvent, Never>()
    private let paginationPublisher = PassthroughSubject<Void, Never>()

    private var cancelBag = Set<AnyCancellable>()

    private var isFetching: Bool = false
    private var isLastFetch: Bool = false

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
        tabBarController?.delegate = self
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

        let viewDidLoadJust = createViewDidLoadPublisher()
        let viewDidRefresh = createRefreshPublisher()
        let pagination = createPaginationPublisher()

        let input = HomeViewModel.Input(
            viewDidLoad: viewDidLoadJust,
            viewDidRefresh: viewDidRefresh,
            pagination: pagination
        )

        let output = viewModel.transform(input: input)

        output.recentHomeFeedList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case .failure(let error): self?.showAlert(message: error.localizedDescription)
                case .finished: return
                }
            } receiveValue: { [weak self] homeFeedList in
                self?.receiveHomeFeedList(homeFeedList: homeFeedList)
            }
            .store(in: &cancelBag)

        output.paginateNormalFeedList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: error.localizedDescription)
                case .finished: return
                }
            } receiveValue: { [weak self] additionalNormalFeed in
                self?.handleAdditionalNormalFeed(additionalNormalFeed)
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

        let output = viewModel.transform(cellInput: cellInput)

        output.scrapSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: error.localizedDescription)
                case .finished: return
                }
            } receiveValue: { [weak self] updateFeed in
                self?.handleUpdateFeed(updateFeed: updateFeed, cell: cell, feedUUID: feedUUID)
            }
            .store(in: &cell.cancelBag)
    }

    // MARK: - bind 내부 함수들 빼줌

    private func createViewDidLoadPublisher() -> AnyPublisher<Void, Never> {
        return Just(Void())
            .filter { _ in
                if !isFetching {
                    isFetching = true
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    private func createRefreshPublisher() -> AnyPublisher<Void, Never> {
        guard let refreshControl = homeView.collectionView.refreshControl else {
            fatalError("리프레쉬 컨트롤러가 존재하지 않아요.")
        }
        return refreshControl.refreshPublisher
            .filter { _ in
                self.isLastFetch = false
                if !self.isFetching {
                    self.isFetching = true
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    private func createPaginationPublisher() -> AnyPublisher<Void, Never> {
        return paginationPublisher
            .filter { _ in
                if !self.isFetching && !self.isLastFetch {
                    self.isFetching = true
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    private func receiveHomeFeedList(homeFeedList: HomeFeedList?) {
        homeView.hideSkeleton()
        guard let homeFeedList = homeFeedList else {
            showAlert(message: "피드 데이터를 가져오는데 에러가 발생했어요")
            return
        }
        // carousel View를 위한 설정 -> 2개씩 복사 해줬으므로 진짜 개수는 3으로 나눠줘야 함
        homeView.setRecommendFeedCount(homeFeedList.recommendFeed.count / 3)
        reloadHomeFeedList(homeFeedList: homeFeedList)
        homeView.endCollectionViewRefreshing()
        isFetching = false
    }

    private func handleAdditionalNormalFeed(_ normalFeed: [Feed]?) {
        guard let normalFeed = normalFeed else {
            showAlert(message: "피드 데이터를 가져오는데 에러가 발생했어요")
            return
        }

        if normalFeed.isEmpty {
            isLastFetch = true
            showToastMessage(text: "모든 피드를 불러왔어요")
        } else {
            reloadHomeFeedList(additional: normalFeed)
        }
        isFetching = false
    }

    private func handleUpdateFeed(updateFeed: Feed?, cell: NormalFeedCell, feedUUID: String) {
        guard let updateFeed = updateFeed else {
            showAlert(message: "업데이트할 피드가 없습니다.")
            return
        }

        if feedUUID == updateFeed.feedUUID {
            cell.footerView.countLabel.text = updateFeed.scrapCount.description
            cell.footerView.scrapButton.isOn = updateFeed.isScraped
            cell.footerView.scrapButton.isEnabled = true
        }
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
            let recommendFeed = viewModel.recommendFeedList[indexPath.row]
            guard let url = URL(string: recommendFeed.url) else {
                showAlert(message: "블로그 URL이 올바르지 않습니다.")
                return
            }
            coordinatorPublisher.send(.moveToBlogSafari(url: url))
            return
        case .normal:
            let feed = viewModel.normalFeedList[indexPath.row]
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
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { isPushOn, _ in
            do {
                try self.viewModel.updateUserScrapState(to: isPushOn)
            } catch {
                self.showAlert(message: error.localizedDescription)
            }
        }
        application.registerForRemoteNotifications()
    }
}

// MARK: - FeedDetail에서 스크랩시 HomeView에 반영

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

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedViewController = tabBarController.selectedViewController else {
            return false
        }
        if viewController == selectedViewController {
            
        }
        return true
    }
}
