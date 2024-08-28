//
//  Color.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

public extension Color {
    
#if os(macOS)
static let background = Color(NSColor.windowBackgroundColor)
static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
#else
static let background = Color(UIColor.systemBackground)
static let secondaryBackground = Color(UIColor.secondarySystemBackground)
static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
#endif
    
    static func setViewBackgroundColor(colorScheme: ColorScheme) -> Color {
        return colorScheme == .light ? Color.secondaryBackground : Color.background
    }

    static func setFieldBackgroundColor(colorScheme: ColorScheme) -> Color {
        return colorScheme == .light ? Color.background : Color.secondaryBackground
    }
}
