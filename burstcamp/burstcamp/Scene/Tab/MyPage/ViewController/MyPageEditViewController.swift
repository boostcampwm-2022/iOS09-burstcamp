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

    enum PHPickerPolicy {
        static let selectionLimit = 1
    }

    private lazy var viewHeight = view.frame.height

    private var myPageEditView: MyPageEditView {
        guard let view = view as? MyPageEditView else {
            return MyPageEditView()
        }
        return view
    }

    private var viewModel: MyPageEditViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinatorPublisher = PassthroughSubject<TabBarCoordinatorEvent, Never>()

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

        myPageEditView.cameraButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.present(self.phpickerViewController, animated: true)
            }
            .store(in: &cancelBag)
    }
}

// MARK: - CoordinatorEvent

extension MyPageEditViewController {
    
    private func showPhotoLibraryModal() {
        coordinatorPublisher.send(.showPhotoLibraryModal)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension MyPageEditViewController: PHPickerViewControllerDelegate {


}

// MARK: - Keyboard Event

extension MyPageEditViewController {

    // TODO: Keyboard event combine
//    var keyboardWillShowPublisher: AnyPublisher<CGFloat, Never> {
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: self)
//            .print("sdsdsdsd")
//            .compactMap { notification in
//                return notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
//            }
//            .print("assasasaasasaas")
//            .map { keyboardFrame in
//                print(keyboardFrame)
//                let keyboardRectangle = keyboardFrame.cgRectValue
//                let keyboardHeight = keyboardRectangle.height
//                let bottomBlankHeight = self.viewHeight - self.myPageEditView.editStackView.frame.maxY
//                return bottomBlankHeight - keyboardHeight - Constant.space12.cgFloat
//            }
//            .print()
//            .eraseToAnyPublisher()
//    }
//
//    var keyboardWillHidePublisher: AnyPublisher<Notification, Never> {
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: self)
//            .eraseToAnyPublisher()
//    }

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
            let bottomBlankHeight = viewHeight - myPageEditView.editStackView.frame.maxY
            let viewY = 0 - keyboardHeight + bottomBlankHeight - Constant.space12.cgFloat
            self.view.frame.origin.y = viewY
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        view.frame.origin.y = 0
    }
}
