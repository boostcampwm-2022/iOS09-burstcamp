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

    private var myPageEditView: MyPageEditView {
        guard let view = view as? MyPageEditView else {
            return MyPageEditView()
        }
        return view
    }

    private var viewModel: MyPageEditViewModel
    private var cancelBag = Set<AnyCancellable>()

    var coordinatorPublisher = PassthroughSubject<TabBarCoordinatorEvent, Never>()
    var imagePickerPublisher = PassthroughSubject<UIImage?, Never>()

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
        output.currentUserInfo
            .sink { userInfo in
                self.myPageEditView.updateCurrentUserInfo(user: userInfo)
            }
            .store(in: &cancelBag)

        output.validationResult
            .sink { validationResult in
                switch validationResult {
                case .validationOK:
                    self.coordinatorPublisher.send(
                        .moveMyPageEditScreenToBackScreen(toastMessage: validationResult.message)
                    )
                default:
                    self.view.endEditing(true)
                    self.showToastMessage(text: validationResult.message)
                }
            }
            .store(in: &cancelBag)

        myPageEditView.cameraButtonTapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.present(self.phpickerViewController, animated: true)
            }
            .store(in: &cancelBag)
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
                    self.myPageEditView.profileImageView.image = image
                    self.imagePickerPublisher.send(image)
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
