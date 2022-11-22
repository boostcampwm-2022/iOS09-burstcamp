//
//  OpenSourceLicenseView.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import UIKit

final class OpenSourceLicenseView: UIView {

    // MARK: - Properties

    private typealias OpenSource = [(name: String, link: String)]

    private let openSources: OpenSource = [
        ("firebase-ios-sdk", "https://github.com/firebase/firebase-ios-sdk"),
        ("Then", "https://github.com/devxoul/Then"),
        ("SnapKit", "https://github.com/SnapKit/SnapKit")
    ]

    private lazy var titleLabel = UILabel().then {
        $0.text = "오픈소스 라이선스"
        $0.textColor = .dynamicBlack
        $0.font = .extraBold24
    }

    private lazy var openSourcesStackView = UIStackView(
        arrangedSubviews: openSources.map {
            openSourceStackView(
                nameLabel: openSourceNameLabel(name: $0.name),
                linkButton: openSourceLinkLabel(link: $0.link)
            )
        }
    ).then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = Constant.space16.cgFloat
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.horizontalEdges.equalToSuperview().inset(Constant.space16)
        }

        addSubview(openSourcesStackView)
        openSourcesStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.space24)
            make.horizontalEdges.equalToSuperview().inset(Constant.space16)
        }
    }

    private func openSourceNameLabel(name: String) -> UILabel {
        return UILabel().then {
            $0.text = name
            $0.textColor = .dynamicBlack
            $0.font = .regular16
        }
    }

    private func openSourceLinkLabel(link: String) -> UIButton {
        return UIButton().then {
            $0.setTitle(link, for: .normal)
            $0.setTitleColor(.main, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.backgroundColor = .clear
            $0.titleLabel?.font = .regular12
        }
    }

    private func openSourceStackView(
        nameLabel: UILabel,
        linkButton: UIButton
    ) -> UIStackView {
        return UIStackView(arrangedSubviews: [nameLabel, linkButton]).then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .fill
            $0.spacing = Constant.space8.cgFloat
        }
    }
}
