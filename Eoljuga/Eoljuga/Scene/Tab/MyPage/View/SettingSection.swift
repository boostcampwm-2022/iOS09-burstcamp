//
//  SettingSection.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/22.
//

import Foundation

enum SettingSection: CaseIterable {
    case setting
    case appInfo

    var index: Int {
        switch self {
        case .setting: return 0
        case .appInfo: return 1
        }
    }
}
