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

    // swiftlint:disable function_body_length
    private func bind() {
        let input = MyPageViewModel.Input(
            myInfoEditButtonTap: myPageView.myInfoEditButtonTapPublisher,
            notificationDidSwitch: myPageView.notificationSwitchStatePublisher,
            darkModeDidSwitch: myPageView.darkModeSwitchStatePublisher,
            withdrawDidTap: withdrawalButtonPublisher
        )

        let output = viewModel.transform(input: input)

        output.updateUserValue
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: "유저 업데이트 중 오류가 발생했어요. \(error.localizedDescription)")
                case .finished: return
                }
            } receiveValue: { [weak self] user in
                self?.myPageView.updateView(user: user)
            }
            .store(in: &cancelBag)

        output.myInfoEdit
            .sink { [weak self] canEdit in
                self?.editMyInfoEdit(canEdit: canEdit)
            }
            .store(in: &cancelBag)

        output.notificationValue
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: "알람 업데이트 중 오류가 발생했어요. \(error.localizedDescription)")
                case .finished: return
                }
            } receiveValue: { [weak self] isOn in
                self?.handleNotificationValue(isOn: isOn)
            }
            .store(in: &cancelBag)

        output.darkModeValue
            .sink { [weak self] appearance in
                self?.myPageView.updateDarkModeSwitch(appearance: appearance)
            }
            .store(in: &cancelBag)

        output.loginProvider
            .sink { [weak self] loginProvider in
                switch loginProvider {
                case .apple:
                    self?.startSignInWithAppleFlow()
                case .github:
                    self?.coordinatorPublisher.send(.moveToGithubLogIn)
                }
            }
            .store(in: &cancelBag)

        output.appVersionValue
            .sink { [weak self] appVersion in
                self?.myPageView.updateAppVersionLabel(appVersion: appVersion)
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
        showAnimatedActivityIndicatorView(description: "탈퇴 중")
        withdrawalButtonPublisher.send(Void())
    }

    private func editMyInfoEdit(canEdit: Bool) {
        if canEdit {
            moveToMyPageEditScreen()
        } else {
            let nextUpdateDate = viewModel.getNextUpdateDate().yearMonthDateFormatString
            showAlert(message: "한 달에 1회 수정 가능해요. 다음 수정 가능 날짜는 \(nextUpdateDate) 이에요.")
        }
    }

    private func handleNotificationValue(isOn: Bool) {
        let text = isOn ? "알림이 켜졌어요" : "알림이 꺼졌어요"
        showToastMessage(text: text, icon: UIImage(systemName: "bell.fill"))
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

extension MyPageViewController {
    func showEditCompleteToastMessage(message: String) {
        self.showToastMessage(text: message)
    }
}

// MARK: - AppDelegate에서 Github으로부터 code를 받아 함수를 호출해줘야 함

extension MyPageViewController {
    func withdrawalWithGithub(code: String) {
        Task { [weak self] in
            self?.updateActivityOverlayDescriptionLabel("유저 정보 삭제 중")
            do {
                try await self?.viewModel.withdrawalWithGithub(code: code)
                self?.hideAnimatedActivityIndicatorView()
                self?.moveToAuthFlow()
            } catch {
                self?.hideAnimatedActivityIndicatorView()
                debugPrint(error.localizedDescription)
                showAlert(message: "유저 정보 삭제 중 에러가 발생했어요. \(error.localizedDescription)")
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
