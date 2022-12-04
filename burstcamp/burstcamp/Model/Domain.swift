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

    var color: UIColor {
        switch self {
        case .iOS: return UIColor.customOrange
        case .android: return UIColor.customGreen
        case .web: return UIColor.customYellow
        }
    }

    var brightColor: UIColor {
        switch self {
        case .iOS: return UIColor.brightOrange
        case .android: return UIColor.brightGreen
        case .web: return UIColor.brightYellow
        }
    }

    var representing: String {
        switch self {
        case .iOS: return "S"
        case .android: return "K"
        case .web: return "J"
        }
    }
}
