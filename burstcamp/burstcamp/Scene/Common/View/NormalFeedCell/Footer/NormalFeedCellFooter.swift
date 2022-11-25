//
//  DefaultFeedCellFooter.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import UIKit

class NormalFeedCellFooter: UIView {

    private lazy var scriptButton = UIButton().then {
        let image = UIImage(systemName: "bookmark")
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.main
    }

    private lazy var countLabel = UILabel().then {
        $0.textColor = UIColor.systemGray2
        $0.font = UIFont.regular12
        $0.text = ""
    }

    private lazy var timeLabel = UILabel().then {
        $0.textColor = UIColor.systemGray2
        $0.font = UIFont.regular12
        $0.text = ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubViews([scriptButton, countLabel, timeLabel])
        configureScriptButton()
        configureCountLabel()
        configureTimeLabel()
    }

    private func configureScriptButton() {
        scriptButton.snp.makeConstraints {
            $0.width.height.equalTo(Constant.Button.script)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    private func configureCountLabel() {
        countLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(scriptButton.snp.trailing).offset(Constant.space2)
        }
    }

    private func configureTimeLabel() {
        timeLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}

extension NormalFeedCellFooter {
    func updateView(feed: Feed) {
        let timeString = BCDateFormatter.relativeTimeString(for: feed.pubDate)
        DispatchQueue.main.async {
            self.countLabel.text = "20"
            self.timeLabel.text = timeString
        }
    }
}
