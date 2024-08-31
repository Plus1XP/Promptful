//
//  PromptView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct PromptView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var promptStore: PromptStore
    @State private var editMode: EditMode = .inactive
    @State var showConfirmationDialogue: Bool = false
//    @State var confirmDeletion: Bool = false
//    @State var animate: Bool = false
//    @State var showOverlay: Bool = false
    @State private var searchText = ""
//    @State private var selectedPrompt: PromptEntity?
    var groupedByDate: [Date: [PromptEntity]] {
        let calendar = Calendar.current
        return Dictionary(grouping: promptStore.prompts) { promptEntity in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: promptEntity.timestamp!)
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    var headers: [Date] {
        groupedByDate.map { $0.key }.sorted(by: { $0 > $1 })
    }
    
    var body: some View {
        List(selection: $promptStore.promptSelection) {
            if self.promptStore.prompts.isEmpty {
                ContentUnavailableView("What inspires you?...", systemImage: "quote.bubble")
            } else {
                ForEach(headers, id: \.self) { header in
                    Section(header: Text(header, style: .date)) {
                        ForEach(groupedByDate[header]!, id: \.self) { prompt in
                            // This Hack removes the Details Disclosure chevron from list view.
                            ZStack {
                                HStack(alignment: .top) {
                                    ListCellView(prompt: prompt)
                                        .padding([.leading/*, .trailing*/], self.editMode.isEditing ? 10 : 0)
                                }
                                NavigationLink(destination: EditPromptsView(prompt: prompt)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0.5, leading: 0, bottom: 0.5, trailing: 0))
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button() {
                                    withAnimation {
                                        // Pin
                                    }
                                } label: {
                                    Label("", systemImage: "pin")
                                        .foregroundStyle(.orange, .orange)
                                }
                                .tint(.clear)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        promptStore.deleteEntry(prompt)
                                    }
                                } label: {
                                    Label("", systemImage: "trash")
                                        .foregroundStyle(.red, .red)
                                }
                                .tint(.clear)
                            }
                        }
                        //                            .onMove(perform: { indices, newOffset in
                        //                                 self.vm.moveEntry(from: indices, to: newOffset)
                        //                            })
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
        //            .id(UUID())
        .onAppear{
            //                self.vm.fetchEntries()
        }
        .refreshable {
            self.promptStore.fetchEntries()
        }
        .searchable(text: $searchText, prompt: "Search Quotes..") {
            if self.searchText.count > 2 {
                ForEach(self.promptStore.prompts, id: \.self) { entry in
                    Text(entry.author!).searchCompletion(entry.author!)
                }
            }
        }
        .onChange(of: searchText) {
            self.promptStore.searchNotes(with: searchText)
        }
        .onChange(of: self.editMode, {
            //            self.noteStore.isPinnedNotesFiltered = false
        })
        .onDisappear(perform: {
            self.editMode = .inactive
            self.promptStore.promptSelection.removeAll()
        })
        .alert("Confirm Deletion", isPresented: $showConfirmationDialogue) {
            Button("Cancel", role: .cancel) {
                self.promptStore.promptSelection.removeAll()
                self.editMode = .inactive
                self.showConfirmationDialogue = false
            }
            Button("Delete", role: .destructive) {
                let feedbackGenerator: UINotificationFeedbackGenerator? = UINotificationFeedbackGenerator()
                feedbackGenerator?.notificationOccurred(.success)
                self.promptStore.deleteSelectedEntries()
                self.editMode = .inactive
                self.showConfirmationDialogue = false
            }
        } message: {
            Text(deletionAlertText(selection: self.promptStore.promptSelection.count))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if self.editMode == .active {
                    HStack {
                        Button(action: {
                            if self.promptStore.promptSelection.isEmpty {
                                for prompt in self.promptStore.prompts {
                                    self.promptStore.promptSelection.insert(prompt)
                                }
                            } else {
                                self.promptStore.promptSelection.removeAll()
                            }
                        }) {
                            Image(systemName: self.promptStore.promptSelection.isEmpty ? "checklist.unchecked" : "checklist.checked")
                                .symbolEffect(.bounce, value: self.promptStore.promptSelection.isEmpty)
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .foregroundStyle(.blue, setFontColor(colorScheme: self.colorScheme))
                        .sensoryFeedback(.selection, trigger: self.promptStore.promptSelection.isEmpty)
                        .disabled(self.editMode == .inactive ? true : false)
                        
                        Button(action: {
                            self.showConfirmationDialogue = true
                        }) {
                            Label("Trash", systemImage: self.showConfirmationDialogue ? "trash.fill" : "trash")
                                .symbolEffect(.pulse.wholeSymbol, options: .repeating, value: self.showConfirmationDialogue)
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .foregroundStyle(self.promptStore.promptSelection.isEmpty ? .gray : .red, .blue)
                        .sensoryFeedback(.warning, trigger: self.showConfirmationDialogue)
                        .disabled(self.promptStore.promptSelection.isEmpty)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        if self.editMode == .inactive {
                            self.editMode = .active
                        }
                        else if self.editMode == .active {                            self.promptStore.promptSelection.removeAll()
                            self.editMode = .inactive
                        }
                    } label: {
                        if self.editMode.isEditing {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.white, .blue)
                        } else {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.gray, .blue)
                        }
                    }
                    .scaleEffect(self.editMode.isEditing ? 1.5 : 1)
                    .animation(.bouncy, value: self.editMode.isEditing)
                    
                    Button {
                        // Create pin filter
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .animation(.spring(), value: self.editMode)
        .environment(\.editMode, $editMode)
    }
}

private func deletionAlertText(selection: Int) -> String {
    if selection == 1 {
        return "Are you sure you want to delete \(selection) Entry?"
    } else {
        return "Are you sure you want to delete \(selection) Entries?"
    }
}

private func setFontColor(colorScheme: ColorScheme) -> Color {
    return colorScheme == .light ? .black : .white
}

#Preview {
    PromptView()
        .environmentObject(PromptStore())
}
