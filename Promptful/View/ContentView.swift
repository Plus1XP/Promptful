//
//  ContentView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var promptStore: PromptStore
    @State private var editMode: EditMode = .inactive
    @State private var isNewQuotePopoverPresented: Bool = false
    @State private var activeTabSelection: Int = 0
    
    var body: some View {
        TabView(selection: $activeTabSelection) {
            NavigationView {
                Group {
                    if promptStore.isDataLoaded {
                        PromptView()
                    } else {
                        ProgressView("Loading...")
                    }
                }
                .navigationTitle("Quotes")
            }
            .tabItem {
                Image(systemName: "text.quote")
                Text("Quotes")
            }
            .sheet(isPresented: $isNewQuotePopoverPresented) {
                EditPromptsView()
                    .padding(.top)
                    .presentationDragIndicator(.visible)
            }
            .tag(0)
            List {
                
            }
            .onAppear(perform: {
                self.editMode = .inactive
                self.activeTabSelection = 0
                self.isNewQuotePopoverPresented = true
            })
            .tabItem {
                Image("custom.quote.bubble.badge.plus")
                Text("Add Quote")
            }
            .tag(1)
            NavigationView {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PromptStore())
}
