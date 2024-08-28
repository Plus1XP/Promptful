//
//  EditPromptsView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct EditPromptsView: View {
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var vm: PromptViewModel
    @State var prompt: PromptEntity?
//    @State private var author: String = ""
//    @State private var quote: String = ""
    @FocusState private var contentEditorInFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleTextFieldView(string: Binding<String>(
                get: {
                    vm.authorText // retrieve the value
                }, set: {
                    vm.registerAuthorUndo($0, in: undoManager) // set the value
                }))
            .submitLabel(.next)
            .onChange(of: vm.authorText, {
                guard let newValueLastChar = vm.authorText.last else { return }
                    if newValueLastChar == "\n" {
                        vm.authorText.removeLast()
                        contentEditorInFocus = true
                    }
                })
            TextEditorView(string: Binding<String>(
                get: {
                    vm.quoteText // retrieve the value
                }, set: {
                  vm.registerQuoteUndo($0, in: undoManager) // set the value
                }))
                .scrollDisabled(true)
                .focused($contentEditorInFocus)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(10)
        // Stops view from dropping down, due to thinking there is a big title.
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        undoManager?.undo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                    .disabled(undoManager?.canUndo == false)
                    Button {
                        undoManager?.redo()
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                    }
                    .disabled(undoManager?.canRedo == false)
                    Button {
                        
                    } label: {
                        Image(systemName: "pin.circle")
                    }
                }
            }
        }
        .onAppear {
            if let prompt = prompt {
                self.vm.authorText = prompt.author ?? ""
                self.vm.quoteText = prompt.quote ?? ""
            } else {
                self.vm.authorText = ""
                self.vm.quoteText = ""
            }
        }
        .onChange(of: vm.authorText + vm.quoteText, {
            debugPrint("Saving Author and Quote changes to CoreData")
            if let prompt = prompt {
                self.updatePrompt(author: vm.authorText, quote: vm.quoteText)
            } else {
                createNewNote()
                self.updatePrompt(author: vm.authorText, quote: vm.quoteText)
            }
        })
    }
    
    // MARK: Core Data Operations
    private func createNewNote() {
        if (vm.authorText.isEmpty) && (vm.quoteText.isEmpty) {
            return
        }
        prompt = nil
        prompt = vm.addNewEntry()
    }
    
    func updatePrompt(author: String, quote: String) {
        if (author.isEmpty) && (quote.isEmpty) {
            return
        }
        guard let prompt = prompt else { return }
        vm.updateEntry(prompt, author: author, quote: quote)
    }
}

#Preview {
    EditPromptsView()
        .environmentObject(PromptViewModel())
}
