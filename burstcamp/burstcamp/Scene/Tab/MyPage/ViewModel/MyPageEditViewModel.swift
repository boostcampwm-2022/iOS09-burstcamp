//
//  MyPageEditViewModel.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import Combine
import Foundation

// TODO: 임시유저삭제
let user = User(
    userUUID: "1",
    name: "하늘이",
    profileImageURL: "",
    domain: .iOS,
    camperID: "S057",
    blogUUID: "",
    signupDate: "",
    scrapFeedUUIDs: [],
    isPushNotification: false
)

let blog = Blog(userUUID: "1", url: "", rssURL: "", title: "")

final class MyPageEditViewModel {

    private var nickNameValidation = true
    private var blogLinkValidation = true

    struct Input {
        let profileImageViewDidEdit: PassthroughSubject<String, Never>
        let nickNameTextFieldDidEdit: AnyPublisher<String, Never>
        let blogLinkFieldDidEdit: AnyPublisher<String, Never>
        let finishEditButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        var currentUserInfo = CurrentValueSubject<(User, Blog), Never>((user, blog))
        var validationResult = PassthroughSubject<MyPageEditValidationResult, Never>()
    }

    func transform(input: Input, cancelBag: inout Set<AnyCancellable>) -> Output {
        configureInput(input: input, cancelBag: &cancelBag)
        return createOutput(from: input, cancelBag: &cancelBag)
    }

    private func configureInput(input: Input, cancelBag: inout Set<AnyCancellable>) {

        // TODO: profileImageViewDidEdit 유저 프로필 url DB, Storage 업데이트
        // input.profileImageViewDidEdit

//        input.profileImageViewDidEdit
//            .sink { profileImageURL in
//            }
//            .store(in: &cancelBag)

        input.nickNameTextFieldDidEdit
            .sink { nickName in
                self.nickNameValidation = NickNameValidation.validate(name: nickName)
            }
            .store(in: &cancelBag)

        input.blogLinkFieldDidEdit
            .sink { blogLink in
                self.blogLinkValidation = BlogLinkValidation.validate(link: blogLink)
            }
            .store(in: &cancelBag)
    }

    private func createOutput(
        from input: Input,
        cancelBag: inout Set<AnyCancellable>
    ) -> Output {
        let output = Output()

        input.finishEditButtonDidTap
            .sink { _ in
                print("탭탭")
                output.validationResult.send(self.validate())
            }
            .store(in: &cancelBag)

        return output
    }

    private func validate() -> MyPageEditValidationResult {
        print(nickNameValidation, blogLinkValidation)
        if nickNameValidation && blogLinkValidation {
            return .validationOK
        } else if nickNameValidation {
            return .blogLinkError
        } else {
            return .nickNameError
        }
    }
}
