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
        $0.addArrangedSubViews([scrapButton, shareButton])
        $0.spacing = Constant.space24.cgFloat
    }
    private lazy var barButtonStackViewItem = UIBarButtonItem(customView: barButtonStackView)

    private let scrapButton = ToggleButton(
        image: UIImage(systemName: "bookmark.fill"),
        onColor: .main,
        offColor: .systemGray4
    )
    private lazy var scrapBarButtonItem = UIBarButtonItem(customView: scrapButton)

    private let shareButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "square.and.arrow.up"),
            for: .normal
        )
    }
    private lazy var shareBarButtonItem = UIBarButtonItem(customView: shareButton)

    private let feedDetailViewModel: FeedDetailViewModel
    private let scrapViewModel: ScrapViewModel
    let coordinatorPublisher = PassthroughSubject<FeedDetailCoordinatorEvent, Never>()
    private var cancelBag: Set<AnyCancellable> = []

    init(
        feedDetailViewModel: FeedDetailViewModel,
        scrapViewModel: ScrapViewModel
    ) {
        self.feedDetailViewModel = feedDetailViewModel
        self.scrapViewModel = scrapViewModel
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

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [barButtonStackViewItem]
    }

    private func bind() {
        // MARK: FeedDetailViewModel

        let feedDetailInput = FeedDetailViewModel.Input(
            viewDidLoad: Just(Void()).eraseToAnyPublisher(),
            blogButtonDidTap: feedDetailView.blogButtonTapPublisher,
            shareButtonDidTap: shareButton.tapPublisher
        )
        let feedDetailOutput = feedDetailViewModel.transform(input: feedDetailInput)

        feedDetailOutput.feedDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feed in
                self?.feedDetailView.configure(with: feed)
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

        // MARK: ScrapViewModel

        let scrapInput = ScrapViewModel.Input(
            scrapToggleButtonDidTap: scrapButton.tapPublisher
        )
        let scrapOutput = scrapViewModel.transform(input: scrapInput)

        scrapOutput.scrapButtonIsEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: scrapButton)
            .store(in: &cancelBag)

        scrapOutput.scrapButtonState
            .receive(on: DispatchQueue.main)
            .assign(to: \.isOn, on: scrapButton)
            .store(in: &cancelBag)

        scrapOutput.showAlert
            .receive(on: DispatchQueue.main)
            .sink { error in
                self.showAlert(message: error.localizedDescription)
            }
            .store(in: &cancelBag)
    }
}
