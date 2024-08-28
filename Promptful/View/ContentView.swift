//
//  ContentView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var promptViewModel: PromptViewModel
    @State private var editMode: EditMode = .inactive
    @State private var isNewQuotePopoverPresented: Bool = false
    @State private var activeTabSelection: Int = 0
    @State private var previousTabSelection: Int = 0
    var body: some View {
        TabView(selection: $activeTabSelection) {
            Group {
                if promptViewModel.isDataLoaded {
                    PromptView()
                } else {
                    ProgressView("Loading...")
                }
            }
            .tabItem {
                Image(systemName: "text.quote")
                Text("Quotes") // Over names could be: Overview, Entries
            }
            .sheet(isPresented: $isNewQuotePopoverPresented) {
                //                NewQuoteView()
                EditPromptsView()
                    .padding(.top)
                    .presentationDragIndicator(.visible)
            }
            .tag(0)
            List {
                
            }
            .onAppear(perform: {
                self.editMode = .inactive
                if self.previousTabSelection == 0 {
                    self.activeTabSelection = 0
                    self.isNewQuotePopoverPresented = true
                } else if self.previousTabSelection == 2 {
                    self.activeTabSelection = 2
                    self.isNewQuotePopoverPresented = true
                }
            })
            .tabItem {
                Image(systemName: getCurrentTabIcon(activeTab: self.activeTabSelection))
                Text(getCurrentTabName(activeTab: self.activeTabSelection))
            }
            .tag(1)
            Text("")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
    }
}

private func getCurrentTabName(activeTab: Int) -> String {
    if activeTab == 0 {
        return "Add Item"
    } else if activeTab == 2 {
        return "Add Note"
    } else {
        return ""
    }
}

private func getCurrentTabIcon(activeTab: Int) -> String {
    if activeTab == 0 {
        return "cart.badge.plus"
    } else if activeTab == 2 {
        return "note.text.badge.plus"
    } else {
        return ""
    }
}


#Preview {
    ContentView()
        .environmentObject(PromptViewModel())
}
