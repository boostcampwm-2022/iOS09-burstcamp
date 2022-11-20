//
//  Domain.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/18.
//

import UIKit

enum Domain: String, Codable {
    case iOS = "iOS"
    case android = "Android"
    case web = "Web"

    init?(rawValue: String) {
        switch rawValue {
        case "iOS": self = .iOS
        case "Android": self = .android
        case "Web": self = .web
        default: return nil
        }
    }

    var color: UIColor {
        switch self {
        case .iOS: return UIColor.customOrange
        case .android: return UIColor.customGreen
        case .web: return UIColor.customYellow
        }
    }

    var representingDomain: String {
        switch self {
        case .iOS: return "S"
        case .android: return "K"
        case .web: return "J"
        }
    }
}
