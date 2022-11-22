//
//  Appearance.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import UIKit

enum Appearance: String {
    case light
    case dark

    var theme: String {
        return self.rawValue
    }

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }

    var switchMode: Bool {
        switch self {
        case .light: return false
        case .dark: return true
        }
    }

    static func appearance(isOn: Bool) -> Appearance {
        return isOn ? .dark : .light
    }
}
