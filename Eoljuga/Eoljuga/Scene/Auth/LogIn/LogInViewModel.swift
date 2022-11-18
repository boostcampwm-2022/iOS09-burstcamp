//
//  LogInViewModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import UIKit

final class LogInViewModel {

    func logInButtonDidTap() {
        LogInManager.shared.requestCode()
    }
}
