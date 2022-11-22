//
//  DarkmodeManager.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import UIKit

struct DarkModeManager {

    static var currentAppearance: Appearance = UserDefaultsManager.currentAppearance() {
        didSet {
            setAppearance(currentAppearance)
        }
    }

    private static func setAppearance(_ appearance: Appearance) {
        UserDefaultsManager.saveAppearance(appearance: appearance)
        setWindowAppearance(appearance: appearance)
    }

    private static func setWindowAppearance(appearance: Appearance) {
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let windows = window.windows.first
            windows?.overrideUserInterfaceStyle = appearance.userInterfaceStyle
        }
    }
}
