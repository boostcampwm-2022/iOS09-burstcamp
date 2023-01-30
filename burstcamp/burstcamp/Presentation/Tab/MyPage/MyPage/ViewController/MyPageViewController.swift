//
//  MyPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import SafariServices
import UIKit

final class MyPageViewController: UIViewController {

    // MARK: - Properties

    private var myPageView: MyPageView {
        guard let view = view as? MyPageView else {
            return MyPageView()
        }
        return view
    }
    private var viewModel: MyPageViewModel
    private var cancelBag = Set<AnyCancellable>()

    var coordinatorPublisher = PassthroughSubject<MyPageCoordinatorEvent, Never>()
    var toastMessagePublisher = PassthroughSubject<String, Never>()
    var withdrawalButtonPublisher = PassthroughSubject<Void, Never>()

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
            notificationDidSwitch: myPageView.notificationSwitchStatePublisher,
            darkModeDidSwitch: myPageView.darkModeSwitchStatePublisher,
            withdrawDidTap: withdrawalButtonPublisher
        )

        let output = viewModel.transform(input: input)

        output.updateUserValue
            .sink { [weak self] user in
                self?.myPageView.updateView(user: user)
            }
            .store(in: &cancelBag)

        output.darkModeInitialValue
            .sink { [weak self] appearance in
                self?.myPageView.updateDarkModeSwitch(appearance: appearance)
            }
            .store(in: &cancelBag)

        output.appVersionValue
            .sink { [weak self] appVersion in
                self?.myPageView.updateAppVersionLabel(appVersion: appVersion)
            }
            .store(in: &cancelBag)

        output.signOutFailMessage
            .sink { [weak self] message in
                self?.showToastMessage(
                    text: message,
                    icon: UIImage(systemName: "exclamationmark.octagon.fill")
                )
            }
            .store(in: &cancelBag)

        output.loginProviderPublisher
            .sink { [weak self] event in
                switch event {
                case .github:
                    self?.coordinatorPublisher.send(.moveToGithubLogIn)
                case .apple:
                    // apple 인증 띄우기
                    return
                }
            }
            .store(in: &cancelBag)

        output.withdrawalStop
            .sink { [weak self] _ in
                self?.hideIndicator()
            }
            .store(in: &cancelBag)

        myPageView.notificationSwitchStatePublisher
            .sink { isOn in
                let text = isOn ? "알림이 켜졌어요." : "알림이 꺼졌어요."
                self.showToastMessage(text: text, icon: UIImage(systemName: "bell.fill"))
            }
            .store(in: &cancelBag)

        myPageView.myInfoEditButtonTapPublisher
            .sink { _ in self.moveToMyPageEditScreen() }
            .store(in: &cancelBag)

        toastMessagePublisher
            .sink { message in
                self.showToastMessage(text: message)
            }
            .store(in: &cancelBag)
    }

    private func setCollectionViewDelegate() {
        myPageView.setCollectionViewDelegate(viewController: self)
    }

    private func showConfirmWithdrawalAlert() {
        let okAction = UIAlertAction(
            title: Alert.yes,
            style: .default
        ) { [weak self] _ in
            self?.showIndicator()
            self?.withdrawal()
        }
        let cancelAction = UIAlertAction(
            title: Alert.no,
            style: .cancel
        )
        showAlert(
            title: Alert.withdrawalTitleMessage,
            message: Alert.withdrawalMessage,
            alertActions: [okAction, cancelAction]
        )
    }

    private func withdrawal() {
        self.coordinatorPublisher.send(.moveToGithubLogIn)
    }

    private func showIndicator() {
        DispatchQueue.main.async {
            self.myPageView.indicatorView.startAnimating()
            self.myPageView.loadingLabel.isHidden = false
            self.setUserInteraction(isEnabled: false)
        }
    }

    private func hideIndicator() {
        DispatchQueue.main.async {
            self.myPageView.indicatorView.stopAnimating()
            self.myPageView.loadingLabel.isHidden = true
            self.setUserInteraction(isEnabled: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MyPageViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let cellIndexPath = CellIndexPath(indexPath: (indexPath.section, indexPath.row))
        switch cellIndexPath {
        case SettingCell.withdrawal.cellIndexPath:
            showConfirmWithdrawalAlert()
        case SettingCell.openSource.cellIndexPath:
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

    private func moveToAuthFlow() {
        coordinatorPublisher.send(.moveToAuthFlow)
    }
}

// MARK: - AppDelegate에서 Github으로부터 code를 받아 함수를 호출해줘야 함

extension MyPageViewController {
    func withDrawalUser(code: String) {
        Task {
            do {
                print("탈퇴하기")
                try await viewModel.deleteUserInfo(code: code)
                self.moveToAuthFlow()
            } catch {
                debugPrint(error.localizedDescription)
                showAlert(message: error.localizedDescription)
            }
        }
    }
}
