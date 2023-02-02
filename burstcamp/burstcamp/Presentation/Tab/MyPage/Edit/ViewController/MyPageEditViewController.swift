//
//  MyPageEditViewController.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import Combine
import PhotosUI
import UIKit

final class MyPageEditViewController: UIViewController {

    // MARK: - Properties

    private enum PHPickerPolicy {
        static let selectionLimit = 1
    }

    private var canChangeNickname = false
    private var canChangeBlog = false

    private var myPageEditView: MyPageEditView {
        guard let view = view as? MyPageEditView else {
            return MyPageEditView()
        }
        return view
    }

    private var viewModel: MyPageEditViewModel

    var coordinatorPublisher = PassthroughSubject<MyPageCoordinatorEvent, Never>()
    var imagePickerPublisher = PassthroughSubject<Data?, Never>()

    private var cancelBag = Set<AnyCancellable>()

    private lazy var phpickerConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = PHPickerPolicy.selectionLimit
        configuration.filter = .images
        return configuration
    }()

    private lazy var phpickerViewController = PHPickerViewController(
        configuration: phpickerConfiguration
    ).then {
        $0.delegate = self
    }

    // MARK: - Initializer

    init(viewModel: MyPageEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = MyPageEditView()
    }

    override func viewDidLoad() {
        configureUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObservers()
    }

    // MARK: - Methods

    private func configureUI() {
    }

    private func bind() {

        let input = MyPageEditViewModel.Input(
            imagePickerPublisher: imagePickerPublisher,
            nickNameTextFieldDidEdit: myPageEditView.nickNameTextFieldTextPublisher,
            blogLinkFieldDidEdit: myPageEditView.blogLinkTextFieldTextPublisher,
            finishEditButtonDidTap: myPageEditView.finishEditButtonTapPublisher
        )

        let output = viewModel.transform(input: input)

        output.editedUser
            .sink { [weak self] user in
                self?.handleEditedUser(user: user)
            }
            .store(in: &cancelBag)

        output.profileImage
            .sink { [weak self] _ in
                self?.handleOutputProfileImage()
            }
            .store(in: &cancelBag)

        output.nicknameValidate
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.showAlert(message: "닉네임 중복 검사 중 에러가 발생했어요. \(error.localizedDescription)")
                case .finished: return
                }
            } receiveValue: { [weak self] nicknameValidation in
                self?.handleOutputNicknameValidate(nicknameValidation)
                self?.setEditButton()
            }
            .store(in: &cancelBag)

        output.blogResult
            .sink { [weak self] blogValidation in
                self?.handleOutputBlogValidation(blogValidation)
                self?.setEditButton()
            }
            .store(in: &cancelBag)

        myPageEditView.cameraButtonTapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.present(self.phpickerViewController, animated: true)
            }
            .store(in: &cancelBag)
    }

    private func handleEditedUser(user: User) {
        myPageEditView.updateCurrentUserInfo(user: user)
    }

    private func handleOutputProfileImage() {
        showToastMessage(text: "이미지를 바꿨어요")
    }

    private func handleOutputNicknameValidate(_ myPageEditNicknameValidation: MyPageEditNicknameValidation?) {
        guard let myPageEditNicknameValidation = myPageEditNicknameValidation else {
            showAlert(message: "닉네임 검사 에러가 발생했어요. (언래핑)")
            return
        }

        switch myPageEditNicknameValidation {
        case .regexError:
            failEditNickname(text: "닉네임 조건에 맞지 않아요. (한, 영, 숫자, _, -, 2-10자)")
        case .duplicateError:
            failEditNickname(text: "중복되는 아이디에요")
        case .success:
            successEditNickname()
        }
    }

    private func failEditNickname(text: String) {
        myPageEditView.updateNickNameDescriptionLabel(text: text, textColor: .customRed)
        myPageEditView.disableEditButton()
        canChangeNickname = false
    }

    private func successEditNickname() {
        myPageEditView.updateNickNameDescriptionLabel(text: "사용 가능한 닉네임이에요", textColor: .customGreen)
        canChangeNickname = true
    }

    private func handleOutputBlogValidation(_ myPageEditBlogValidation: MyPageEditBlogValidation?) {
        guard let myPageEditBlogValidation = myPageEditBlogValidation else {
            showAlert(message: "블로그 검사 에러가 발생했어요. (언래핑)")
            return
        }

        switch myPageEditBlogValidation {
        case .regexError:
            failEditBlogURL()
        case .success:
            successEditBlogURL()
        }
    }

    private func failEditBlogURL() {
        myPageEditView.updateBlogLinkDescriptionLabel(
            text: "Blog URL을 확인해주세요. 현재 Tistory와 Velog만 지원하고 있어요",
            textColor: .customRed
        )
        myPageEditView.disableEditButton()
        canChangeBlog = false
    }

    private func successEditBlogURL() {
        myPageEditView.updateBlogLinkDescriptionLabel(text: "사용 가능한 블로그에요 (URL 없어도 가능해요)", textColor: .customGreen)
        canChangeBlog = true
    }

    private func setEditButton() {
        if canChangeNickname && canChangeBlog {
            myPageEditView.enableEditButton()
        } else {
            myPageEditView.disableEditButton()
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension MyPageEditViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    let image = image as? UIImage
                    self.myPageEditView.updateImage(image)
                    let imageData = image?.jpegData(compressionQuality: 0.2)
                    self.imagePickerPublisher.send(imageData)
                }
            }
        }
    }
}

// MARK: - Keyboard Event

extension MyPageEditViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame = noti.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let bottomBlankHeight = view.frame.height - myPageEditView.editStackView.frame.maxY
            let viewY = 0 - keyboardHeight + bottomBlankHeight - Constant.space12.cgFloat
            self.view.frame.origin.y = viewY
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        view.frame.origin.y = 0
    }
}
