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

    private var dataSource: UICollectionViewDiffableDataSource<FeedCellType, Feed>!
    private var collectionViewSnapshot: NSDiffableDataSourceSnapshot<FeedCellType, Feed>!

    private let viewModel: ScrapPageViewModel

    let coordinatorPublisher = PassthroughSubject<ScrapPageCoordinatorEvent, Never>()
    private let paginationPublisher = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()

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
        guard let refreshControl = scrapPageView.collectionView.refreshControl
        else { return }

        let viewDidLoadJust = Just(Void()).eraseToAnyPublisher()

        let input = ScrapPageViewModel.Input(
            viewDidLoad: viewDidLoadJust,
            viewDidRefresh: refreshControl.refreshPublisher,
            pagination: paginationPublisher.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.recentScrapFeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scrapFeedList in
                self?.refreshScrapFeedList(scrapFeedList: scrapFeedList)
            }
            .store(in: &cancelBag)

        output.moreFeed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scrapFeedList in
                self?.reloadScrapFeedList(additional: scrapFeedList)
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
                self?.scrapPageView.endCollectionViewRefreshing()
            }
            .store(in: &cancelBag)

        output.showToast
            .receive(on: DispatchQueue.main)
            .sink { message in
                self.showToastMessage(text: message)
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
        configureEmptyView()

        let previousScrapFeedData = collectionViewSnapshot.itemIdentifiers(inSection: .normal)
        collectionViewSnapshot.deleteItems(previousScrapFeedData)

        collectionViewSnapshot.appendItems(scrapFeedList, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
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
