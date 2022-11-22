//
//  UserDefaultManager.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/21.
//

import Foundation

struct UserDefaultsManager {

    private static let appearanceKey = "Appearance"

    static func saveAppearance(appearance: Appearance) {
        UserDefaults.standard.set(appearance.theme, forKey: appearanceKey)
    }

    static func appearance() -> Appearance? {
        guard let appearanceString = UserDefaults.standard.string(forKey: appearanceKey)
        else { return nil }
        return Appearance(rawValue: appearanceString)
    }
}
