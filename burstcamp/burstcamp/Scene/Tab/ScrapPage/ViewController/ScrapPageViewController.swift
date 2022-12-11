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

    private var viewModel: ScrapPageViewModel
    private var cancelBag = Set<AnyCancellable>()
    let coordinatorPublisher = PassthroughSubject<ScrapPageCoordinatorEvent, Never>()
    private let paginationPublisher = PassthroughSubject<Void, Never>()

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
        configureUI()
        bind()
        collectionViewDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    // MARK: - Methods

    private func configureUI() {
    }

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

//        output.fetchResult
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] fetchResult in
//                switch fetchResult {
//                case .fetchSuccess:
//                    self?.scrapPageView.endCollectionViewRefreshing()
//                    self?.scrapPageView.collectionView.reloadData()
//                case .fetchFail(let error):
//                    print(error)
//                }
//            }
//            .store(in: &cancelBag)

//        output.cellUpdate
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] indexPath in
//                self?.reloadCollectionView(indexPath: indexPath)
//            }
//            .store(in: &cancelBag)
    }

    private func collectionViewDelegate() {
        scrapPageView.collectionViewDelegate(viewController: self)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "모아보기"
        navigationController?.isNavigationBarHidden = false
    }

    private func paginateFeed() {
        paginationPublisher.send(Void())
    }

    private func reloadCollectionView(indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            scrapPageView.collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension ScrapPageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NormalFeedCell.identifier,
            for: indexPath
        ) as? NormalFeedCell
        else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        let feed = viewModel.scrapFeedData[index]
        let cellViewModel = viewModel.dequeueCellViewModel(at: index)

        cell.configure(with: cellViewModel)
        cell.updateFeedCell(with: feed)

        return cell
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
