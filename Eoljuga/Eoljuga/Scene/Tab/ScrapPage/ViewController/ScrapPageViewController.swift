//
//  ScrapPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import UIKit

final class ScrapPageViewController: UIViewController {

    // MARK: - Properties

    private var scrapPageView: ScrapPageView {
        guard let view = view as? ScrapPageView else {
            return ScrapPageView()
        }
        return view
    }

    private var viewModel: ScrapPageViewModel

    // MARK: - Initializer

    init(viewModel: ScrapPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = ScrapPageView()
    }

    override func viewDidLoad() {
        configureUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    // MARK: - Methods

    private func configureUI() {
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "모아보기"
    }

    private func bind() {
    }
}
