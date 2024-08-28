//
//  PromptfulApp.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

@main
struct PromptfulApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var promptViewModel = PromptViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(self.promptViewModel)
        }
    }
}
