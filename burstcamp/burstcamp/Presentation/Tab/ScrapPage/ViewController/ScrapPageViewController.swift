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
    private let viewWillAppearPublisher = PassthroughSubject<Void, Never>()
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
        configureDataSource()
        bind()
        collectionViewDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        viewWillAppearPublisher.send(Void())
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

        let input = ScrapPageViewModel.Input(
            viewWillAppear: viewWillAppearPublisher.eraseToAnyPublisher(),
            viewDidRefresh: refreshControl.refreshPublisher,
            pagination: paginationPublisher.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.scrapPageView.collectionView.reloadData()
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
    }

    private func bindNormalFeedCell(_ cell: NormalFeedCell, index: Int, feedUUID: String) {

        let scrapButtonDidTap = cell.getButtonTapPublisher()
            .map { _  in
                cell.footerView.scrapButton.isEnabled = false
                return index
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
        print("스크롤")
//        paginationPublisher.send(Void())
    }
}

extension ScrapPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if viewModel.scrapFeedData.isEmpty {
            collectionView.configureEmptyView()
        } else {
            collectionView.resetEmptyView()
        }
        return viewModel.scrapFeedData.count
    }

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
        let feed = viewModel.scrapFeedData[indexPath.row]
        coordinatorPublisher.send(.moveToFeedDetail(feed: feed))
    }
}

// MARK: - DataSource
extension ScrapPageViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: scrapPageView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NormalFeedCell.identifier,
                    for: indexPath
                ) as? NormalFeedCell
                else {
                    return UICollectionViewCell()
                }
                let index = indexPath.row
                let feed = self.viewModel.scrapFeedData[index]
                self.bindNormalFeedCell(cell, index: index, feedUUID: feed.feedUUID)
                cell.updateFeedCell(with: feed)
                return cell
            })

        collectionViewSnapshot = NSDiffableDataSourceSnapshot<FeedCellType, Feed>()
        collectionViewSnapshot.appendSections([.normal])
        collectionViewSnapshot.appendItems(viewModel.scrapFeedData, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
    }

    private func refreshSnapshot(scrapFeedData: [Feed]) {
        let previousScrapFeedData = collectionViewSnapshot.itemIdentifiers(inSection: .normal)
        collectionViewSnapshot.deleteItems(previousScrapFeedData)

        collectionViewSnapshot.appendItems(scrapFeedData, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
    }

    private func reloadSnapshot(scrapFeedData: [Feed]) {
        collectionViewSnapshot.appendItems(scrapFeedData, toSection: .normal)
        dataSource.apply(collectionViewSnapshot, animatingDifferences: false)
    }
}
