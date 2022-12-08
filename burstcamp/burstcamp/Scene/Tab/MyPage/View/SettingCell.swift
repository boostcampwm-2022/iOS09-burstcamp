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
    case withdrawal
    case appInfoHeader
    case openSource
    case appVersion

    var title: String {
        switch self {
        case .settingHeader: return "설정"
        case .notification: return "알림설정"
        case .darkMode: return "다크모드"
        case .withdrawal: return "탈퇴하기"
        case .appInfoHeader: return "앱 정보"
        case .openSource: return "오픈소스 라이선스"
        case .appVersion: return "앱 버전"
        }
    }

    var section: SettingSection {
        switch self {
        case .settingHeader, .notification, .darkMode, .withdrawal:
            return .setting
        case .appInfoHeader, .openSource, .appVersion:
            return .appInfo
        }
    }

    var icon: UIImage? {
        switch self {
        case .notification: return UIImage(systemName: "bell.fill")
        case .darkMode: return UIImage(systemName: "moon.fill")
        case .withdrawal: return UIImage(systemName: "airplane.departure")
        default: return nil
        }
    }

    var index: Int {
        switch self {
        case .settingHeader: return 0
        case .notification: return 1
        case .darkMode: return 2
        case .withdrawal: return 3
        case .appInfoHeader: return 0
        case .openSource: return 1
        case .appVersion: return 2
        }
    }

    var cellIndexPath: CellIndexPath {
        switch self {
        case .settingHeader:
            return CellIndexPath(
                indexPath: (SettingSection.setting.index, self.index)
            )
        case .notification:
            return CellIndexPath(
                indexPath: (SettingSection.setting.index, self.index)
            )
        case .darkMode:
            return CellIndexPath(
                indexPath: (SettingSection.setting.index, self.index)
            )
        case .withdrawal:
            return CellIndexPath(
                indexPath: (SettingSection.setting.index, self.index)
            )
        case .appInfoHeader:
            return CellIndexPath(
                indexPath: (SettingSection.appInfo.index, self.index)
            )
        case .openSource:
            return CellIndexPath(
                indexPath: (SettingSection.appInfo.index, self.index)
            )
        case .appVersion:
            return CellIndexPath(
                indexPath: (SettingSection.appInfo.index, self.index)
            )
        }
    }
}
