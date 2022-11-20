//
//  MyPageView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

final class MyPageView: UIView {

    // MARK: - Properties

    private let user: User

    private lazy var myPageProfileView = MyPageProfileView(
        user: user
    )

    private let myInfoEditButton = DefaultButton(
        title: "내 정보 수정하기",
        font: .bold14,
        backgroundColor: UIColor.customBlue
    )

    // MARK: - Initializer

    init(frame: CGRect, user: User) {
        self.user = user
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func configureUI() {
        addSubview(myPageProfileView)
        myPageProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Constant.space16)
            make.trailing.equalToSuperview().inset(Constant.space16)
            make.height.equalTo(Constant.Profile.height)
        }

        addSubview(myInfoEditButton)
        myInfoEditButton.snp.makeConstraints { make in
            make.top.equalTo(myPageProfileView.snp.bottom)
                .offset(Constant.space16)
            make.leading.equalToSuperview().offset(Constant.space16)
            make.trailing.equalToSuperview().inset(Constant.space16)
            make.height.equalTo(Constant.Button.editButton)
        }
    }
}
