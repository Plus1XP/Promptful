//
//  Appearence.swift
//  Promptful
//
//  Created by nabbit on 02/09/2024.
//

import SwiftUI

enum AppearanceType: String, Codable, CaseIterable, Identifiable {
    case automatic
    case dark
    case light

    var id: Self {
        return self
    }

    var label: String {
        switch self {
        case .automatic:
            "Automatic"
        case .dark:
            "Dark"
        case .light:
            "Light"
        }
    }
}

extension AppearanceType {
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic:
                .none
        case .dark:
                .dark
        case .light:
                .light
        }
    }
    
    var userInerfaceStyle: UIUserInterfaceStyle? {
        switch self {
        case .automatic:
                .unspecified
        case .dark:
                .dark
        case .light:
                .light
        }
    }
    
    var symbolChoice: String {
        switch self {
        case .automatic:
            "moonphase.first.quarter"
        case .dark:
            "moon"
        case .light:
            "sun.max"
        }
    }
    
    var primarySymbolColor: Color {
        switch self {
        case .automatic:
            Color.gray
        case .dark:
            Color.gray
        case .light:
            Color.yellow
        }
    }
    
    var secondarySymbolColor: Color {
        switch self {
        case .automatic:
            Color.yellow
        case .dark:
            Color.gray
        case .light:
            Color.yellow
        }
    }
}
