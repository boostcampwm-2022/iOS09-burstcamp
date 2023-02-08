//
//  FeedDetailViewController.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import Combine
import UIKit

import Then

final class FeedDetailViewController: UIViewController {

    private var feedDetailView: FeedDetailView {
        guard let view = view as? FeedDetailView else {
            return FeedDetailView()
        }
        return view
    }

    private lazy var barButtonStackView = UIStackView().then {
        $0.addArrangedSubViews([scrapButton, shareButton, ellipsisButton])
        $0.spacing = Constant.space24.cgFloat
    }
    private lazy var barButtonStackViewItem = UIBarButtonItem(customView: barButtonStackView)

    private let scrapButton = ToggleButton(
        image: UIImage(systemName: "bookmark.fill"),
        onColor: .main,
        offColor: .systemGray5
    )
    private let shareButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "square.and.arrow.up"),
            for: .normal
        )
    }

    private let ellipsisButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "ellipsis"),
            for: .normal
        )
    }

    private let feedDetailViewModel: FeedDetailViewModel

    let coordinatorPublisher = PassthroughSubject<FeedDetailCoordinatorEvent, Never>()
    private var updateFeedPublisher = PassthroughSubject<Feed, Never>()
    private var deleteFeedPublisher = PassthroughSubject<Feed, Never>()
    private var actionSheetPublisher = PassthroughSubject<ActionSheetEvent, Never>()
    private var cancelBag = Set<AnyCancellable>()

    init(
        feedDetailViewModel: FeedDetailViewModel
    ) {
        self.feedDetailViewModel = feedDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = FeedDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureNavigationBar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [barButtonStackViewItem]
    }

    private func bind() {
        // MARK: FeedDetailViewModel

        let scrapButtonDidTap = scrapButton.tapPublisher
            .map { [weak self] _ in
                self?.scrapButton.isEnabled = false
                return
            }
            .eraseToAnyPublisher()

        ellipsisButton.tapPublisher
            .sink { _ in
                self.showActionSheet()
            }
            .store(in: &cancelBag)

        let feedDetailInput = FeedDetailViewModel.Input(
            viewDidLoad: Just(Void()).eraseToAnyPublisher(),
            blogButtonDidTap: feedDetailView.blogButtonTapPublisher,
            shareButtonDidTap: shareButton.tapPublisher,
            scrapButtonDidTap: scrapButtonDidTap,
            actionSheetEvent: actionSheetPublisher.eraseToAnyPublisher()
        )
        let feedDetailOutput = feedDetailViewModel.transform(input: feedDetailInput)

        feedDetailOutput.feedDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: "피드를 불러오는 중 에러가 발생했어요. \(error.localizedDescription)")
                case .finished: return
                }
            } receiveValue: { [weak self] feed in
                self?.handleFeedDidUpdate(feed)
            }
            .store(in: &cancelBag)

        feedDetailOutput.openBlog
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.coordinatorPublisher.send(.moveToBlogSafari(url: url))
            }
            .store(in: &cancelBag)

        feedDetailOutput.openActivityView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feedURL in
                let shareViewController = UIActivityViewController(
                    activityItems: [feedURL],
                    applicationActivities: nil
                )
                shareViewController.popoverPresentationController?.sourceView = self?.feedDetailView

                self?.present(shareViewController, animated: true)
            }
            .store(in: &cancelBag)

        feedDetailOutput.scrapUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: "스크랩 중에 에러가 발생했어요. \(error.localizedDescription)")
                case .finished: return
                }
            } receiveValue: { [weak self] feed in
                self?.updateFeedScrap(feed)
            }
            .store(in: &cancelBag)

        feedDetailOutput.actionSheetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: "에러가 발생했어요. \(error.localizedDescription)")
                case .finished: return
                }
            } receiveValue: { [weak self] feed in
                self?.handleBlockReportFeed(feed)
            }
            .store(in: &cancelBag)
    }

    private func handleFeedDidUpdate(_ feed: Feed?) {
        guard let feed = feed else {
            return
        }
        scrapButton.isOn = feed.isScraped
        feedDetailView.configure(with: feed)
    }

    private func updateFeedScrap(_ feed: Feed?) {
        guard let feed = feed else {
            showAlert(message: "스크랩 하던 중 Feed 정보에 에러가 발생했어요")
            return
        }
        scrapButton.isOn = feed.isScraped
        publishUpdateFeed(feed)
        scrapButton.isEnabled = true
    }

    private func publishUpdateFeed(_ feed: Feed) {
        updateFeedPublisher.send(feed)
    }

    private func handleBlockReportFeed(_ feed: Feed?) {
        guard let feed = feed else {
            debugPrint("피드 없음")
            return
        }
        // 부모 뷰 CollectionView에 feed 전달
        deleteFeedPublisher.send(feed)
        coordinatorPublisher.send(.moveToPreviousScreen)
    }
}

extension FeedDetailViewController {
    func getUpdateFeedPublisher() -> AnyPublisher<Feed, Never> {
        return updateFeedPublisher.eraseToAnyPublisher()
    }

    func getDeleteFeedPublisher() -> AnyPublisher<Feed, Never> {
        return deleteFeedPublisher.eraseToAnyPublisher()
    }
}

extension FeedDetailViewController {
    func showActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "신고하기", style: .default) { _ in
            self.actionSheetPublisher.send(.report)
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "차단하기", style: .default) { _ in
            self.actionSheetPublisher.send(.report)
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)

        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)

        DispatchQueue.main.async {
            self.present(actionSheetController, animated: true)
        }
    }
}
