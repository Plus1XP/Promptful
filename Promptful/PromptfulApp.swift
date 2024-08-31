//
//  PromptfulApp.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

@main
struct PromptfulApp: App {
    @StateObject private var promptViewModel = PromptStore()
    @StateObject private var biometricStore = BiometricStore()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(self.promptViewModel)
                .environmentObject(self.biometricStore)
        }
    }
}
