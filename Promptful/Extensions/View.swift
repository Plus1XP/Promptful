//
//  View.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func displayConfetti(isActive: Binding<Bool>) -> some View {
        self.modifier(DisplayConfettiModifier(isActive: isActive))
    }
}
