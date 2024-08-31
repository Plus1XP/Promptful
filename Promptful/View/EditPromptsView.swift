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
    @State private var author: String = ""
    @State private var quote: String = ""
    @FocusState private var isFocus: PromptField?
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleTextFieldView(string: Binding<String>(
                get: {
                    self.author
                }, set: {
                    if let index = self.vm.prompts.firstIndex(where: {$0 === self.prompt}) {
                        self.author = vm.registerAuthorUndo(index: index, newValue: $0, in: self.undoManager)
                    } else {
                        self.author = $0
                    }
                }))
            .submitLabel(.next)
            .focused($isFocus, equals: .author)
            .onChange(of: self.author, {
                guard let newValueLastChar = self.author.last else { return }
                    if newValueLastChar == "\n" {
                        self.author.removeLast()
                        self.isFocus = .quote
                    }
                })
            
            TextEditorView(string: Binding<String>(
                get: {
                    self.quote
                }, set: {
                    if let index = self.vm.prompts.firstIndex(where: {$0 === self.prompt}) {
                        self.quote = vm.registerQuoteUndo(index: index, newValue: $0, in: self.undoManager)
                    } else {
                        self.quote = $0
                    }
                }))
                .scrollDisabled(true)
                .focused($isFocus, equals: .quote)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(10)
        // Stops view from dropping down, due to thinking there is a big title.
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        if let prompt = self.prompt {
                            self.undoManager?.undo()
                            self.author = prompt.author ?? ""
                            self.quote = prompt.quote  ?? ""
                        }
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                    .disabled(self.undoManager?.canUndo == false)
                    Button {
                        if let prompt = self.prompt {
                            self.undoManager?.redo()
                            self.author = prompt.author  ?? ""
                            self.quote = prompt.quote  ?? ""
                        }
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
//            self.vm.undoManager = undoManager
            if let prompt = self.prompt {
                self.author = prompt.author ?? ""
                self.quote = prompt.quote ?? ""
            } else {
                self.author = ""
                self.quote = ""
            }
        }
        .onChange(of: self.author + self.quote, {
            self.saveChanges()
        })
        .onDisappear{
            // delete empty quote
        }
    }
    
    private func saveChanges() {
        if self.prompt != nil {
            self.updatePrompt(author: self.author, quote: self.quote)
        } else {
            self.createNewPrompt(author: self.author, quote: self.quote)
            self.updatePrompt(author: self.author, quote: self.quote)
        }
    }

    private func createNewPrompt(author: String, quote: String) {
        if (author.isEmpty) && (quote.isEmpty) {
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
