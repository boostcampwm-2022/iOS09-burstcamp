//
//  DefaultSignUpUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultSignUpUseCase: SignUpUseCase {

    private let signUpRepository: SignUpRepository
    private let userRepository: UserRepository
    private let blogRepository: BlogRepository

    init(signUpRepository: SignUpRepository, userRepository: UserRepository, blogRepository: BlogRepository) {
        self.signUpRepository = signUpRepository
        self.userRepository = userRepository
        self.blogRepository = blogRepository
    }
}
