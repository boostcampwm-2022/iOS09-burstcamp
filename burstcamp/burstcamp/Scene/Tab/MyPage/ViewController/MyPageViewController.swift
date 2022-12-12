//
//  MyPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import Combine
import SafariServices
import UIKit

import FirebaseAuth

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
    var withdrawalPublisher = PassthroughSubject<Void, Never>()

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
            withdrawDidTap: withdrawalPublisher
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

        output.moveToLoginFlow
            .sink { _ in
                self.moveToAuthFlow()
            }
            .store(in: &cancelBag)

        output.withdrawalStop
            .sink { [weak self] _ in
                self?.setUserInteraction(isEnabled: true)
                self?.myPageView.indicatorView.stopAnimating()
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
        ) { _ in
            self.setUserInteraction(isEnabled: false)
            self.myPageView.indicatorView.startAnimating()

            LogInManager.shared.changeIsWithdrawal(bool: true)
            self.coordinatorPublisher.send(.moveToGithubLogIn)
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

    private func setUserInteraction(isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.view.isUserInteractionEnabled = isEnabled
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
