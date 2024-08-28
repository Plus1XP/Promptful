//
//  PromptView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct PromptView: View {
    @EnvironmentObject var vm: PromptViewModel
    @State var showConfirmationDialogue: Bool = false
    @State var showOverlay: Bool = false
    @State private var searchText = ""
    @State private var selectedPrompt: PromptEntity?
    var groupedByDate: [Date: [PromptEntity]] {
        let calendar = Calendar.current
        return Dictionary(grouping: vm.prompts) { promptEntity in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: promptEntity.timestamp!)
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    var headers: [Date] {
        groupedByDate.map { $0.key }.sorted(by: { $0 > $1 })
    }
    
    var body: some View {
        NavigationSplitView {
            // sidebar
            List(selection: $selectedPrompt) {
                if self.vm.prompts.isEmpty {
                    ContentUnavailableView("What inspires you?...", systemImage: "quote.bubble")
                } else {
                    ForEach(headers, id: \.self) { header in
                        Section(header: Text(header, style: .date)) {
                            ForEach(groupedByDate[header]!) { prompt in
                                // This Hack removes the Details Disclosure chevron from list view.
                                ZStack {
                                    HStack(alignment: .top) {
                                        ListCellView(prompt: prompt)
                                    }
                                    NavigationLink(destination: EditPromptsView(prompt: prompt)
                                        .id(prompt)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                }
//                                NavigationLink(value: prompt) {
//                                    ListCellView(prompt: prompt)
//                                }
                                .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            vm.deleteEntry(prompt)
                                            
                                        }
                                    } label: {
                                        Label("", systemImage: "trash")
                                            .foregroundStyle(.red, .red)
                                    }
                                    .tint(.clear)
                                }
                            }
//                            .onDelete(perform: { indexSet in
//                                deleteNote(in: header, at: indexSet)
//                            })
                        }
                    }
                    .listRowBackground(
                        Rectangle()
                            .fill(Color(.clear).opacity(1))
                    )
                }
            }
            .id(UUID())
            .navigationTitle("Quotes")
            .searchable(text: $searchText, prompt: "Search Quotes..")
            .onChange(of: searchText) {
                // MARK: Core Data Operations
                vm.searchNotes(with: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Create pin filter
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        } detail: {
            // item details
            if let selectedPrompt {
                EditPromptsView(prompt: selectedPrompt)
                    .id(selectedPrompt)
            } else {
                Text("Select a Quote.")
            }
            
        }
    }
    
    // MARK: Core Data Operations
    
    private func deleteNote(in header: Date, at offsets: IndexSet) {
        offsets.forEach { index in
            if let promptToDelete = groupedByDate[header]?[index] {
                
                if promptToDelete == selectedPrompt {
                    selectedPrompt = nil
                }
                
                vm.deleteEntry(promptToDelete)
            }
        }
    }
}

#Preview {
    PromptView()
        .environmentObject(PromptViewModel())
}
