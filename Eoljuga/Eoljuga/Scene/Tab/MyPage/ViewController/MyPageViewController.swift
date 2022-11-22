//
//  MyPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import UIKit

final class MyPageViewController: UIViewController {

    // MARK: - Properties

    // TODO: 임시 유저
    private var user = User(
        userUUID: "test",
        name: "NEULiee",
        profileImageURL: "",
        domain: .iOS,
        camperID: "S057",
        blogUUID: "",
        signupDate: "",
        scrapFeedUUIDs: [],
        isPushNotification: false
    )

    private var myPageView: MyPageView {
        guard let view = view as? MyPageView else {
            return MyPageView()
        }
        return view
    }
    private var viewModel: MyPageViewModel
    private var cancelBag = Set<AnyCancellable>()

    var coordinatorPublisher = PassthroughSubject<TabBarCoordinatorEvent, Never>()

    // MARK: - Initializer

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = MyPageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        setCollectionViewDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    // MARK: - Methods

    private func configureUI() {
        view.backgroundColor = .background
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "마이페이지"
    }

    private func bind() {
        let input = MyPageViewModel.Input(
            darkModeValueChanged: myPageView.darkModeSwitch.controlPublisher(for: .valueChanged)
                .compactMap { $0 as? UISwitch }
                .compactMap { Appearance.appearance(isOn: $0.isOn) }
                .eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input, cancelBag: &cancelBag)
        output.darkModeInitialValue
            .sink { appearance in
                self.myPageView.setDarkModeSwitch(appearance: appearance)
            }
            .store(in: &cancelBag)

        myPageView.myInfoEditButton.tapPublisher
            .sink { _ in self.moveToMyPageEditScreen() }
            .store(in: &cancelBag)
    }

    private func setCollectionViewDelegate() {
        myPageView.setCollectionViewDelegate(viewController: self)
    }
}

// MARK: - UICollectionViewDelegate

extension MyPageViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // TODO: 기능 추가
        switch (indexPath.section, indexPath.row) {
        case (0, 3): // TODO: 탈퇴 alert
            break
        case (1, 1):
            moveToOpenSourceScreen()
        default: break
        }

        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

// MARK: - TabBarCoordinatorEvent

extension MyPageViewController {
    private func moveToMyPageEditScreen() {
        coordinatorPublisher.send(.moveToMyPageEditScreen)
    }

    private func moveToOpenSourceScreen() {
        coordinatorPublisher.send(.moveToOpenSourceScreen)
    }
}
