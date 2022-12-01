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

    private let viewModel: FeedDetailViewModel
    private var cancelBag: Set<AnyCancellable> = []

    init(viewModel: FeedDetailViewModel) {
        self.viewModel = viewModel
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [barButtonStackViewItem]
    }

    private func bind() {
        let input = FeedDetailViewModel.Input(
            blogButtonDidTap: feedDetailView.blogButtonTapPublisher,
            scrapButtonDidTap: scrapButton.statePublisher,
            shareButtonDidTap: shareButton.tapPublisher
        )

        let output = viewModel.transform(input: input)

        output.feedDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { feed in
                self.feedDetailView.configure(with: feed)
            }
            .store(in: &cancelBag)

        output.openBlog
            .receive(on: DispatchQueue.main)
            .sink { url in
                UIApplication.shared.open(url)
            }
            .store(in: &cancelBag)

        output.openActivityView
            .receive(on: DispatchQueue.main)
            .sink { feedURL in
                let shareViewController = UIActivityViewController(
                    activityItems: [feedURL],
                    applicationActivities: nil
                )
                shareViewController.popoverPresentationController?.sourceView = self.feedDetailView

                self.present(shareViewController, animated: true)
            }
            .store(in: &cancelBag)

        output.scrapButtonToggle
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.scrapButton.toggle()
            }
            .store(in: &cancelBag)

        output.scrapButtonIsEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: scrapButton)
            .store(in: &cancelBag)
    }
}
