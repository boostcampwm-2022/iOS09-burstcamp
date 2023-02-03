//
//  FeedDetailView.swift
//  Eoljuga
//
//  Created by SEUNGMIN OH on 2022/11/22.
//

import UIKit
import WebKit

import SnapKit
import Then

final class FeedDetailView: UIView {

    private let deviceWidth = UIScreen.main.bounds.width
    private let scrollView = UIScrollView()

    private lazy var userInfoStackView = DefaultUserInfoView()
    private lazy var feedInfoStackView = FeedInfoStackView()
    private lazy var contentView = FeedContentWebView()

    private lazy var blogButton = DefaultButton(title: "블로그 바로가기")
    lazy var blogButtonTapPublisher = blogButton.tapPublisher

    private let loadingFeedViewTag = 1000
    private var isWebViewLoaded = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureDelegate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDelegate() {
        contentView.navigationDelegate = self
    }

    private func configureUI() {
        backgroundColor = .background
        addSubViews([scrollView, blogButton])

        scrollView.addSubViews([userInfoStackView, feedInfoStackView, contentView])

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(blogButton.snp.top).offset(-Constant.space12)
        }

        blogButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(Constant.Button.defaultButton)
        }

        userInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constant.space8)
            $0.leading.equalToSuperview().inset(Constant.space12)
        }

        feedInfoStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(Constant.space8)
        }

        contentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.height.equalTo(0)
            $0.top.equalTo(feedInfoStackView.snp.bottom).offset(Constant.space24)
            $0.bottom.equalToSuperview().offset(-Constant.space12)
        }
    }

    private func updateContentViewConstraints(height: CGFloat) {
        contentView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }

    private func showContent(feedContent: String) {
        if feedContent.isEmpty {
            removeContentView()
            showEmptyFeedView()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if !self.isWebViewLoaded {
                    self.showLoadingFeedView()
                }
            }
            contentView.loadFormattedHTMLString(feedContent)
        }
    }

    private func removeContentView() {
        contentView.snp.removeConstraints()
        contentView.removeFromSuperview()
    }

    private func showEmptyFeedView() {
        let emptyFeedView = EmptyFeedView()
        scrollView.addSubview(emptyFeedView)
        emptyFeedView.backgroundColor = .systemPink

        emptyFeedView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self)
        }
    }

    private func showLoadingFeedView() {
        let loadingFeedView = LoadingFeedView()
        loadingFeedView.tag = loadingFeedViewTag

        scrollView.addSubview(loadingFeedView)

        loadingFeedView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self)
        }
    }
}

extension FeedDetailView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        DispatchQueue.main.async {
            self.isWebViewLoaded = true
            self.viewWithTag(self.loadingFeedViewTag)?.removeFromSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let contentViewHeight = webView.scrollView.contentSize.height
            self.updateContentViewConstraints(height: contentViewHeight)
        }
    }
}

extension FeedDetailView {
    func configure(with feed: Feed) {
        userInfoStackView.updateView(feedWriter: feed.writer)
        feedInfoStackView.updateView(feed: feed)
        showContent(feedContent: feed.content)
    }
}
