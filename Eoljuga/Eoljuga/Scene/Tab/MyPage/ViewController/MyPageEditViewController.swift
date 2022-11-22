//
//  MyPageEditViewController.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

final class MyPageEditViewController: UIViewController {

    // MARK: - Properties

    private var myPageEditView: MyPageEditView {
        guard let view = view as? MyPageEditView else {
            return MyPageEditView()
        }
        return view
    }

    private var viewModel: MyPageEditViewModel

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

    // MARK: - Methods

    private func configureUI() {
    }

    private func bind() {
    }
}
