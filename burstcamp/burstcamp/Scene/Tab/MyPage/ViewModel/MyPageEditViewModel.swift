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
    userUUID: "",
    nickname: "하늘이",
    profileImageURL: "https://avatars.githubusercontent.com/u/39167842?v=4",
    domain: .iOS,
    camperID: "S057",
    ordinalNumber: 7,
    blogURL: "https://luen.tistory.com",
    blogTitle: "성이 하씨고 이름이 늘이",
    scrapFeedUUIDs: [],
    signupDate: Date(),
    isPushOn: false
)

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
        var currentUserInfo = CurrentValueSubject<User, Never>(user)
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
                output.validationResult.send(self.validate())
            }
            .store(in: &cancelBag)

        return output
    }

    private func validate() -> MyPageEditValidationResult {
        if nickNameValidation && blogLinkValidation {
            return .validationOK
        } else if nickNameValidation {
            return .blogLinkError
        } else {
            return .nickNameError
        }
    }
}
