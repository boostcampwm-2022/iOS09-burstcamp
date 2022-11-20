//
//  Constant.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/17.
//

import Foundation

enum Constant {
    static let zero = 0
    static let space2 = 2
    static let space4 = 4
    static let space6 = 6
    static let space8 = 8
    static let space10 = 10
    static let space12 = 12
    static let space16 = 16
    static let space24 = 24
    static let space32 = 32
    static let space48 = 48

    enum Padding {
        static let padding2 = 2
        static let padding8 = 8
        static let horizontal = 16
    }

    enum Cell {
        static let recommendWidth = 300
        static let recommendHeight = 150
        static let recommendMargin = 15

        static let normalHeight = 150
        static let normalTopMargin = 5
        static let normalHeaderHeight = 40
        static let normalMainHeight = 75
        static let normalFooterHeight = 30
    }

    enum Profile {
        static let height = 100
    }

    enum Image {
        static let profileSmall = 24
        static let profileMedium = 64
        static let profileLarge = 100
        static let thumbnailWidth = 100
        static let thumbnailHeight = 100
        static let thumbnailCornerRadius = 10
    }

    enum Button {
        static let script = 24
        static let editButton = 40
        static let defaultButton = 48
    }

    enum CornerRadius {
        static let radius8 = 8
        static let radius12 = 12
    }
}
