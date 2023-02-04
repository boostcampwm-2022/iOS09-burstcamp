//
//  ScrapPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Combine
import UIKit

final class ScrapPageViewController: UIViewController {

    // MARK: - Properties

    private var scrapPageView: ScrapPageView {
        guard let view = view as? ScrapPageView else {
            return ScrapPageView()
        }
        return view
    }

    private let viewModel: ScrapPageViewModel

    private var dataSource: UICollectionViewDiffableDataSource<FeedCellType, Feed>!
    private var collectionViewSnapshot: NSDiffableDataSourceSnapshot<FeedCellType, Feed>!

    let coordinatorPublisher = PassthroughSubject<ScrapPageCoordinatorEvent, Never>()
    private let paginationPublisher = PassthroughSubject<Void, Never>()

    private var cancelBag = Set<AnyCancellable>()

    private var isFetching: Bool = false
    private var isLastFetch: Bool = false
    private let paginateCount = 10
    // MARK: - Initializer

    init(viewModel: ScrapPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = ScrapPageView()
    }

    override func viewDidLoad() {
        collectionViewDelegate()
        configureDataSource()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func collectionViewDelegate() {
        scrapPageView.collectionViewDelegate(viewController: self)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "모아보기"
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Methods

    private func bind() {

        let viewDidLoadPublisher = createViewDidLoadPublisher()
        let viewRefreshPublisher = createViewRefreshPublisher()
        let paginationPublisher = createPaginationPublisher()

        let input = ScrapPageViewModel.Input(
            viewDidLoad: viewDidLoadPublisher,
            viewDidRefresh: viewRefreshPublisher,
            pagination: paginationPublisher
        )

        let output = viewModel.transform(input: input)

        output.recentScrapFeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: error.localizedDescription)
                case .finished: return
                }
            } receiveValue: { [weak self] scrapFeedList in
                self?.handleRecentScrapFeedList(scrapFeedList)
            }
            .store(in: &cancelBag)

        output.paginateScrapFeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: error.localizedDescription)
                case .finished: return
                }
            } receiveValue: { [weak self] scrapFeedList in
                self?.handleAdditionalScrapFeedList(scrapFeedList)
            }
            .store(in: &cancelBag)
    }

    private func bindNormalFeedCell(_ cell: NormalFeedCell, feedUUID: String) {

        let scrapButtonDidTap = cell.getButtonTapPublisher()
            .map { _  in
                cell.footerView.scrapButton.isEnabled = false
                return feedUUID
            }
            .eraseToAnyPublisher()

        let cellInput = ScrapPageViewModel.CellInput(
            scrapButtonDidTap: scrapButtonDidTap
        )

        let cellOutput = viewModel.transform(cellInput: cellInput)

        cellOutput.scrapSuccess
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

    private func createViewRefreshPublisher() -> AnyPublisher<Void, Never> {
        guard let refreshControl = scrapPageView.collectionView.refreshControl else {
            fatalError("리프레쉬 컨트롤러가 존재하지 않아요.")
        }
        return refreshControl.refreshPublisher
            .filter { _ in
                self.isLastFetch = false
                if !self.isFetching {
                    self.isFetching = true
                    return true
                } else {
                    self.scrapPageView.endCollectionViewRefreshing()
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    private func createPaginationPublisher() -> AnyPublisher<Void, Never> {
        return paginationPublisher
            .filter { _ in
                if !self.isFetching && !self.isLastFetch && self.viewModel.getCount() >= self.paginateCount {
                    self.isFetching = true
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    private func handleRecentScrapFeedList(_ scrapFeedList: [Feed]?) {
        scrapPageView.endCollectionViewRefreshing()

        guard let scrapFeedList = scrapFeedList else {
            showAlert(message: "피드 데이터를 가져오는데 에러가 발생했어요")
            return
        }

        if scrapFeedList.isEmpty {
            isLastFetch = true
        }

        refreshScrapFeedList(scrapFeedList: scrapFeedList)
        isFetching = false
    }

    private func handleAdditionalScrapFeedList(_ scrapFeedList: [Feed]?) {
        guard let scrapFeedList = scrapFeedList else {
            showAlert(message: "피드 데이터를 가져오는데 에러가 발생했어요")
            return
        }

        if scrapFeedList.isEmpty {
            isLastFetch = true
        } else {
            reloadScrapFeedList(additional: scrapFeedList)
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

    private func paginateFeed() {
        paginationPublisher.send(Void())
    }
}

extension ScrapPageViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width - Constant.Padding.horizontal.cgFloat * 2
        return CGSize(width: width, height: 150)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isOverTarget() {
            paginateFeed()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let feed = viewModel.scrapFeedList[indexPath.row]
        coordinatorPublisher.send(.moveToFeedDetail(feed: feed))
    }
}

// MARK: - DataSource
extension ScrapPageViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<NormalFeedCell, Feed> { cell, _, feed in
            self.bindNormalFeedCell(cell, feedUUID: feed.feedUUID)
            cell.updateFeedCell(with: feed)
        }
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: scrapPageView.collectionView,
            cellProvider: { collectionView, indexPath, feed in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: feed)
            })

        collectionViewSnapshot = NSDiffableDataSourceSnapshot<FeedCellType, Feed>()
        collectionViewSnapshot.appendSections([.normal])
        collectionViewSnapshot.appendItems(viewModel.scrapFeedList, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
    }

    private func refreshScrapFeedList(scrapFeedList: [Feed]) {
        let previousScrapFeedData = collectionViewSnapshot.itemIdentifiers(inSection: .normal)
        collectionViewSnapshot.deleteItems(previousScrapFeedData)

        collectionViewSnapshot.appendItems(scrapFeedList, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
        configureEmptyView()
    }

    private func reloadScrapFeedList(additional scrapFeedList: [Feed]) {
        collectionViewSnapshot.appendItems(scrapFeedList, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
    }

    private func configureEmptyView() {
        if viewModel.scrapFeedList.isEmpty {
            scrapPageView.collectionView.configureEmptyView()
        } else {
            scrapPageView.collectionView.resetEmptyView()
        }
    }
}

extension ScrapPageViewController: ContainFeedDetailViewController {
    func configure(scrapUpdatePublisher: AnyPublisher<Feed, Never>) {
        scrapUpdatePublisher
            .sink { [weak self] feed in
                guard let feedList = self?.viewModel.updateScrapFeed(feed) else {
                    self?.showAlert(message: "피드 업데이트 중 에러가 발생했습니다.")
                    return
                }
                self?.refreshScrapFeedList(scrapFeedList: feedList)
            }
            .store(in: &cancelBag)
    }
}

extension ScrapPageViewController: ContainScrollViewController {
    func scrollToTop() {
        scrapPageView.collectionViewScrollToTop()
    }
}
