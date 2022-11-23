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

    private lazy var userInfoStackView = DefaultUserInfoView()

    private lazy var feedInfoStackView = UIStackView().then {
        $0.addArrangedSubViews([titleLabel, blogTitleLabel, pubDateLabel])
        $0.axis = .vertical
        $0.spacing = 5
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = .extraBold16
        $0.textColor = .dynamicBlack
        $0.numberOfLines = 3
    }

    private lazy var blogTitleLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .systemGray2
    }

    private lazy var pubDateLabel = UILabel().then {
        $0.font = .regular12
        $0.textColor = .dynamicBlack
    }

    // TODO: WebView에서 HTML content보여주기
    private lazy var contentWebView = WKWebView()

    private lazy var blogButton = DefaultButton(title: "블로그 바로가기")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        fetchMockData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .background
        addSubViews([userInfoStackView, feedInfoStackView, contentWebView, blogButton])

        blogButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.bottom.equalToSuperview().inset(Constant.space24)
            $0.height.equalTo(Constant.Button.defaultButton)
        }

        userInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.trailing.lessThanOrEqualToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(safeAreaLayoutGuide)
        }

        feedInfoStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(Constant.space24)
        }

        contentWebView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.Padding.horizontal)
            $0.top.equalTo(feedInfoStackView.snp.bottom).offset(Constant.space24)
            $0.bottom.equalTo(blogButton.snp.top).offset(-Constant.space24)
        }
    }

    private func fetchMockData() {
        titleLabel.text = "[iOS] Generic 오류 (URLSession과 Decode를 곁들인)"
        blogTitleLabel.text = "성이 하씨고 이름이 늘이"
        pubDateLabel.text = "2022. 10. 12. 22:19"
        contentWebView.loadHTMLString(#"<p data-ke-size="size16">URLSession의 요청이 많아지다보니 공통화를 하고싶어서 Generic에 손을 댔는데</p><p data-ke-size="size16"> </p><p data-ke-size="size16">생각지도 못한 오류 때문에 시간을 많이 잡아 먹었다.</p><p data-ke-size="size16"> </p><p data-ke-size="size16">해결책도 사실 근본적인 해결책이라고 볼 순 없지만.. 적어놓고 나중에 완전히 이해되면 다시 볼 생각으로 글을 적어보려고한다.</p><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><h4 data-ke-size="size20">오류상황</h4><p data-ke-size="size16">현재 NetworkManager에 모든 URLSession 작업과 Encode, Decode 함수를 넣어놨는데 </p><p data-ke-size="size16"> </p><p data-ke-size="size16">Decode 함수를 제네릭으로 만들고 request 함수에서 호출하려고 보니 오류가 발생했다.</p><p data-ke-size="size16"> </p><p data-ke-size="size16">처음으로 발생한 오류 : 일반 매개변수 T를 유추할 수 없습니다.</p><blockquote data-ke-style="style3">Generic parameter 'T' could not be inferred</blockquote><pre class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>private func decode&lt;T: Decodable&gt;(data: Data?) -&gt; T? {    let decoder = JSONDecoder()    guard let data = data else { return nil }    do {        return try decoder.decode(T.self, from: data)    } catch {        print(error.localizedDescription)    }    return nil}private func request&lt;T: Decodable&gt;(requestType: RequestType,                                   url: URL,                                   data: Data? = nil,                                   completion: @escaping (T) -&gt; Void) {    let request = makeRequest(requestType: requestType, url: url, data: data)    URLSession.shared.dataTask(with: request) { data, response, error in        if let error = error {            print("Network Error: \(error.localizedDescription)")            return        }        guard let response = response as? HTTPURLResponse, (200 ..&lt; 299) ~= response.statusCode else {            print("Error: HTTP request failed")            return        }        if let data = data,           let decodedData = self.decode(data: data) { // 오류발생 !            completion(decodedData)        }    }.resume()}</code></pre><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><p data-ke-size="size16">그래서 생각한 해결책</p><pre class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>if let data = data,   let decodedData = self.decode(data: data) {    completion(decodedData)}-----&gt;if let data = data,   let decodedData = self.decode&lt;T&gt;(data: data) {    completion(decodedData)}</code></pre><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><p data-ke-size="size16">오류 : 일반 함수를 명시적으로 특수화할 수 없습니다.</p><blockquote data-ke-style="style3">Cannot explicitly specialize a generic function</blockquote><p data-ke-size="size16"> </p><p data-ke-size="size16">ㅇㅅㅇ? </p><pre class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>if let data = data,   let decodedData = self.decode&lt;T&gt;(data: data) {    completion(decodedData)}if let data = data,   let decodedData = self.decode&lt;User&gt;(data: data) {    completion(decodedData)}if let data = data,   let decodedData = self.decode&lt;User.self&gt;(data: data) {    completion(decodedData)}if let data = data,   let decodedData = self.decode&lt;User.Type&gt;(data: data) {    completion(decodedData)}</code></pre><p data-ke-size="size16"> </p><p data-ke-size="size16">그래서 잠시 별짓을 다해봤는데 안돼서 열심히 구글링을 한 결과..</p><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><p data-ke-size="size16"> </p><p data-ke-size="size16"><a href="https://codegrepr.com/question/cannot-explicitly-specialize-a-generic-function/" target="_blank" rel="noopener">https://codegrepr.com/question/cannot-explicitly-specialize-a-generic-function/</a></p><figure contenteditable="false" data-ke-type="opengraph" data-ke-align="alignCenter" data-og-type="article" data-og-title="Cannot explicitly specialize a generic function - Codegrepr" data-og-description="I have issue with following code: func generic1&lt;T&gt;(name : String){ } func generic2&lt;T&gt;(name : String){ generic1&lt;T&gt;(name) } the" data-og-host="codegrepr.com" data-og-source-url="https://codegrepr.com/question/cannot-explicitly-specialize-a-generic-function/" data-og-url="https://codegrepr.com/question/cannot-explicitly-specialize-a-generic-function/" data-og-image="https://scrap.kakaocdn.net/dn/bm0Qsr/hyP8aEwvQF/raBGeA9acfAWLnufxu1Ojk/img.jpg?width=64&amp;height=64&amp;face=14_26_36_50,https://scrap.kakaocdn.net/dn/RsKnW/hyP8bDqVLo/Lw91B9zI2VCjkboj5KQzmk/img.jpg?width=64&amp;height=64&amp;face=14_26_36_50,https://scrap.kakaocdn.net/dn/bRBrky/hyP74EjPWO/lI2LsnaKMTTPA0KjTZO5D0/img.jpg?width=64&amp;height=64&amp;face=14_26_36_50"><a href="https://codegrepr.com/question/cannot-explicitly-specialize-a-generic-function/" target="_blank" rel="noopener" data-source-url="https://codegrepr.com/question/cannot-explicitly-specialize-a-generic-function/"><div class="og-image"> </div><div class="og-text"><p class="og-title" data-ke-size="size16">Cannot explicitly specialize a generic function - Codegrepr</p><p class="og-desc" data-ke-size="size16">I have issue with following code: func generic1&lt;T&gt;(name : String){ } func generic2&lt;T&gt;(name : String){ generic1&lt;T&gt;(name) } the</p><p class="og-host" data-ke-size="size16">codegrepr.com</p></div></a></figure><p data-ke-size="size16"> </p><p data-ke-size="size16">여기서 설명과 해결책을 주었는데</p><p data-ke-size="size16">최소한 매개변수나 반환값에 T를 사용하거나 타입을 명시해주어야한다..? 여서</p><p data-ke-size="size16">매개변수에 type을 지정하게 해주니 오류가 사라졌다.</p><p data-ke-size="size16"> </p><p data-ke-size="size16">제네릭을 다시 상세하게 문서를 찾아봐야겠다..</p><pre class="swift" data-ke-language="swift" data-ke-type="codeblock"><code>private func decode&lt;T: Decodable&gt;(data: Data?, type: T.Type) -&gt; T? {    let decoder = JSONDecoder()    guard let data = data else { return nil }    do {        return try decoder.decode(T.self, from: data)    } catch {        print(error.localizedDescription)    }    return nil}private func request&lt;T: Decodable&gt;(genericType: T.Type,                                   requestType: RequestType,                                   url: URL,                                   data: Data? = nil,                                   completion: @escaping (T) -&gt; Void) {    let request = makeRequest(requestType: requestType, url: url, data: data)    URLSession.shared.dataTask(with: request) { data, response, error in        if let error = error {            print("Network Error: \(error.localizedDescription)")            return        }        guard let response = response as? HTTPURLResponse, (200 ..&lt; 299) ~= response.statusCode else {            print("Error: HTTP request failed")            return        }        if let data = data,           let decodedData = self.decode(data: data, type: T.self) {            completion(decodedData)        }    }.resume()}</code></pre><div class="another_category another_category_color_gray"><h4>'<a href="https://luen.tistory.com/category/iOS">iOS</a> &gt; <a href="https://luen.tistory.com/category/iOS/STUDY">STUDY</a>' 카테고리의 다른 글</h4><table><tr><th><a href="https://luen.tistory.com/203?category=1006267">[iOS] UITabBarController, UITabBar</a>  <span>(0)</span></th><td>2022.09.01</td></tr><tr><th><a href="https://luen.tistory.com/198?category=1006267">[iOS] Static, Dynamic Library, Framework</a>  <span>(0)</span></th><td>2022.06.20</td></tr><tr><th><a href="https://luen.tistory.com/195?category=1006267">[iOS] Compositional Layout 에 관하여</a>  <span>(2)</span></th><td>2022.06.03</td></tr><tr><th><a href="https://luen.tistory.com/192?category=1006267">[iOS] 카카오 로그인 이해하기</a>  <span>(0)</span></th><td>2022.05.18</td></tr><tr><th><a href="https://luen.tistory.com/188?category=1006267">[iOS] UIToolbar 이슈 (UIToolbarContentView, UIButtonBarStackView)</a>  <span>(0)</span></th><td>2022.04.29</td></tr></table></div>"#, baseURL: nil)
    }
}
