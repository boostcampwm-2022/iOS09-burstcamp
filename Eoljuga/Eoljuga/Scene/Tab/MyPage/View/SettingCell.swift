//
//  SettingCell.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import UIKit

enum SettingCell: CaseIterable {
    case settingHeader
    case notification
    case darkMode
    case withDrawal
    case appInfoHeader
    case openSource
    case appVersion

    var title: String {
        switch self {
        case .settingHeader: return "설정"
        case .notification: return "알림설정"
        case .darkMode: return "다크모드"
        case .withDrawal: return "탈퇴하기"
        case .appInfoHeader: return "앱 정보"
        case .openSource: return "오픈소스 라이선스"
        case .appVersion: return "앱 버전"
        }
    }

    var section: SettingSection {
        switch self {
        case .settingHeader, .notification, .darkMode, .withDrawal:
            return .setting
        case .appInfoHeader, .openSource, .appVersion:
            return .appInfo
        }
    }

    var icon: UIImage? {
        switch self {
        case .notification: return UIImage(systemName: "bell.fill")
        case .darkMode: return UIImage(systemName: "moon.fill")
        case .withDrawal: return UIImage(systemName: "airplane.departure")
        default: return nil
        }
    }
}
