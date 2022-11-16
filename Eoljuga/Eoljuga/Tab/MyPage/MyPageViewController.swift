//
//  MyPageViewController.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/15.
//

import UIKit

class MyPageViewController: UIViewController {
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(logoutButtonTouched), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 지우기
        view.backgroundColor = .systemBrown
        configureLogoutButton()
        // Do any additional setup after loading the view.
    }

    func configureLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.center.equalToSuperview()
        }
    }

    @objc func logoutButtonTouched() {
        print("버튼 터치")
    }
}
