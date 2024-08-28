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
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
//            NavigationView {
                Group {
                    if promptViewModel.isDataLoaded {
                        PromptView()
                    } else {
                        ProgressView("Loading...")
                    }
                }
//            }
            .tabItem {
                Image(systemName: "text.quote")
                Text("Quotes") // Over names could be: Overview, Entries
            }
            .tag(0)
//            NavigationView {
//                
//            }
            Text("")
            .tabItem {
                Image(systemName: "plus.circle")
                Text("Add Quote")
            }
            .tag(1)
//            NavigationView {
//                
//            }
            Text("")
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
        .environmentObject(PromptViewModel())
}
