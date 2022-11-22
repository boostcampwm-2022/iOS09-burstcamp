//
//  DarkmodeManager.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import UIKit

struct DarkModeManager {

    static func setAppearance(_ appearance: Appearance) {
        UserDefaultsManager.saveAppearance(appearance: appearance)
        setWindowAppearance(appearance: appearance)
    }

    static func appearance() -> Appearance {
        return UserDefaultsManager.appearance() == nil ? .light : .dark
    }

    private static func setWindowAppearance(appearance: Appearance) {
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let windows = window.windows.first
            windows?.overrideUserInterfaceStyle = appearance.userInterfaceStyle
        }
    }
}
