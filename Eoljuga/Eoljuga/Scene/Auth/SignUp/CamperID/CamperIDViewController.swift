//
//  CamperIDViewController.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/19.
//

import Combine
import UIKit

final class CamperIDViewController: UIViewController {

    private var camperIDView: CamperIDView {
        guard let view = view as? CamperIDView else { return CamperIDView() }
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
        self.view = CamperIDView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        viewModel.$domain.sink { domain in
            self.camperIDView.domainLabel.text = domain.rawValue
            self.camperIDView.representingDomainLabel.text = domain.representingDomain
        }
        .store(in: &cancelBag)
    }
}
