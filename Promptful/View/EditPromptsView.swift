//
//  EditPromptsView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct EditPromptsView: View {
    @Environment(\.presentationMode) var presentaionMode
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
                    self.vm.authorText // retrieve the value
                }, set: {
                    self.vm.registerAuthorUndo($0, in: self.undoManager) // set the value
                }))
            .submitLabel(.next)
            .onChange(of: self.vm.authorText, {
                guard let newValueLastChar = self.vm.authorText.last else { return }
                    if newValueLastChar == "\n" {
                        self.vm.authorText.removeLast()
                        self.contentEditorInFocus = true
                    }
                })
            TextEditorView(string: Binding<String>(
                get: {
                    self.vm.quoteText // retrieve the value
                }, set: {
                    self.vm.registerQuoteUndo($0, in: self.undoManager) // set the value
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
                        self.undoManager?.undo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                    .disabled(self.undoManager?.canUndo == false)
                    Button {
                        self.undoManager?.redo()
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                    }
                    .disabled(self.undoManager?.canRedo == false)
                    Button {
                        
                    } label: {
                        Image(systemName: "pin.circle")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        self.hideKeyboard()
                        self.saveChanges()
                        self.presentaionMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .onAppear {
            if let prompt = self.prompt {
                self.vm.authorText = prompt.author ?? ""
                self.vm.quoteText = prompt.quote ?? ""
            } else {
                self.vm.authorText = ""
                self.vm.quoteText = ""
            }
        }
        .onChange(of: self.vm.authorText + self.vm.quoteText, {
            self.saveChanges()
        })
    }
    
    private func saveChanges() {
        if self.prompt != nil {
            self.updatePrompt(author: self.vm.authorText, quote: self.vm.quoteText)
        } else {
            self.createNewPrompt()
            self.updatePrompt(author: self.vm.authorText, quote: self.vm.quoteText)
        }
    }

    private func createNewPrompt() {
        if (self.vm.authorText.isEmpty) && (self.vm.quoteText.isEmpty) {
            return
        }
        self.prompt = nil
        self.prompt = self.vm.addNewEntry()
    }
    
    private func updatePrompt(author: String, quote: String) {
        if (author.isEmpty) && (quote.isEmpty) {
            return
        }
        guard let prompt = self.prompt else { return }
        self.vm.updateEntry(prompt, author: author, quote: quote)
    }
}

#Preview {
    EditPromptsView()
        .environmentObject(PromptViewModel())
}
