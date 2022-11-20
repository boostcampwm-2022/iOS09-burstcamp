//
//  CamperIDViewController.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import UIKit

final class SignUpCamperIDViewController: UIViewController {

    private var signUpCamperIDView: SignUpCamperIDView {
        guard let view = view as? SignUpCamperIDView else { return SignUpCamperIDView() }
        return view
    }

    var cancelBag = Set<AnyCancellable>()
    var coordinatorPublisher = PassthroughSubject<(AuthCoordinatorEvent, SignUpViewModel), Never>()
    let viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = SignUpCamperIDView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        viewModel.$domain.sink { domain in
            self.signUpCamperIDView.domainLabel.text = domain.rawValue
            self.signUpCamperIDView.representingDomainLabel.text = domain.representingDomain
        }
        .store(in: &cancelBag)
    }
}
