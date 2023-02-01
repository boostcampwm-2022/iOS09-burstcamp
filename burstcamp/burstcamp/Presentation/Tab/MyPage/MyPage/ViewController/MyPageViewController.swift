//
//  MyPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import AuthenticationServices
import Combine
import SafariServices
import UIKit

final class MyPageViewController: AppleAuthViewController {

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
            myInfoEditButtonTap: myPageView.myInfoEditButtonTapPublisher,
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
                    self?.startSignInWithAppleFlow()
                }
            }
            .store(in: &cancelBag)

        output.withdrawalStop
            .sink { [weak self] _ in
                self?.hideAnimatedActivityIndicatorView()
            }
            .store(in: &cancelBag)

        output.myInfoEditButtonTap
            .sink { [weak self] canEdit in
                self?.editMyInfoEdit(canEdit: canEdit)
            }
            .store(in: &cancelBag)

        myPageView.notificationSwitchStatePublisher
            .sink { isOn in
                let text = isOn ? "알림이 켜졌어요." : "알림이 꺼졌어요."
                self.showToastMessage(text: text, icon: UIImage(systemName: "bell.fill"))
            }
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
            self?.showAnimatedActivityIndicatorView()
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
        self.withdrawalButtonPublisher.send(Void())
    }

    private func editMyInfoEdit(canEdit: Bool) {
        if canEdit {
            moveToMyPageEditScreen()
        } else {
            let nextUpdateDate = viewModel.getNextUpdateDate().yearMonthDateFormatString
            showAlert(message: "한 달에 1회 수정 가능해요. 다음 수정 가능 날짜는 \(nextUpdateDate) 이에요.")
        }
    }

    private func withdrawalWithApple(idTokenString: String, nonce: String) {
        Task { [weak self] in
            self?.updateActivityOverlayDescriptionLabel("유저 정보 삭제 중")
            do {
                try await viewModel.withdrawalWithApple(idTokenString: idTokenString, nonce: nonce)
                self?.moveToAuthFlow()
            } catch {
                self?.showAlert(message: "애플 로그인에 실패했습니다. \(error.localizedDescription)")
            }
            self?.hideAnimatedActivityIndicatorView()
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
    func withdrawalWithGithub(code: String) {
        Task { [weak self] in
            self?.updateActivityOverlayDescriptionLabel("유저 정보 삭제 중")
            do {
                try await self?.viewModel.withdrawalWithGithub(code: code)
                self?.moveToAuthFlow()
            } catch {
                debugPrint(error.localizedDescription)
                showAlert(message: error.localizedDescription)
            }
        }
    }
}

extension MyPageViewController: ASAuthorizationControllerDelegate {
    func startSignInWithAppleFlow() {
        let request = getAppleLoginRequest()

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            withdrawalWithApple(idTokenString: idTokenString, nonce: nonce)
        }
    }
}
