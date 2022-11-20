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
            return MyPageView(user: user)
        }
        return view
    }
    private var viewModel: MyPageViewModel

    // TODO: 추후 삭제
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        return button
    }()

    var coordinatorPublisher = PassthroughSubject<CoordinatorEvent, Never>()

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
        view = MyPageView(user: user)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()

        // TODO: 추후 삭제
        configureLogoutButton()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationItem.title = "마이페이지"
    }

    // TODO: 추후 삭제
    private func configureLogoutButton() {
//        view.addSubview(logoutButton)
//        logoutButton.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(16)
//            $0.height.equalTo(44)
//            $0.center.equalToSuperview()
//        }
    }

    private func bind() {
    }

    // TODO: 추후 삭제
    @objc func logoutButtonDidTap() {
        moveToAuthFlow()
    }
}

extension MyPageViewController {
    func moveToAuthFlow() {
        coordinatorPublisher.send(.moveToAuthFlow)
    }
}
