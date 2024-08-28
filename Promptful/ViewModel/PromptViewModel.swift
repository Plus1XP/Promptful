//
//  PromptViewModel.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

//import Combine
import CoreData
import SwiftUI

class PromptViewModel: ObservableObject {
    @Published var prompts: [PromptEntity] = []
    @Published var promptSelection: Set<PromptEntity> = []
    @Published var authorText: String = ""
    @Published var quoteText: String = ""
//    @Published var searchText: String = ""
    @Published var isDataLoaded = false
    var promptPositionState: [UUID:Int64] = [:]
//    var searchResults: [PromptEntity] {
//        guard !self.searchText.isEmpty else { return self.prompts }
//        return self.prompts.filter { $0.quote!.contains(self.searchText)
//        }
//    }
    
    init() {
        fetchEntries()
    }
    
//    guard !self.searchText.isEmpty else { return prompts }
//    return self.prompts.filter { $0.quote!.contains(self.searchText)}
    
//    func registerUndo(_ newValue: String, _ targetValue: Binding<String>, in undoManager: UndoManager?) {
//        let oldValue = targetValue
//        undoManager?.registerUndo(withTarget: self) { [weak undoManager] target in
//          target.targetValue = oldValue // registers an undo operation to revert to old text
//          target.registerUndo(oldValue, in: undoManager) // this makes redo possible
//        }
//        targetValue = newValue // update the actual value
//      }
    
    func registerAuthorUndo(_ newValue: String, in undoManager: UndoManager?) {
        let oldValue = authorText
        undoManager?.registerUndo(withTarget: self) { [weak undoManager] target in
          target.authorText = oldValue // registers an undo operation to revert to old text
          target.registerAuthorUndo(oldValue, in: undoManager) // this makes redo possible
        }
        authorText = newValue // update the actual value
      }
    
    func registerQuoteUndo(_ newValue: String, in undoManager: UndoManager?) {
        let oldValue = quoteText
        undoManager?.registerUndo(withTarget: self) { [weak undoManager] target in
          target.quoteText = oldValue // registers an undo operation to revert to old text
          target.registerQuoteUndo(oldValue, in: undoManager) // this makes redo possible
        }
        quoteText = newValue // update the actual value
      }
    
    func searchNotes(with searchText: String) {
        fetchEntries(with: searchText)
    }
    
    func fetchEntries(with searchText: String = "") {
        let request = NSFetchRequest<PromptEntity>(entityName: "PromptEntity")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
                request.sortDescriptors = [sort]
        if !searchText.isEmpty {
            let authorPredicate = NSPredicate(format: "author CONTAINS[c] %@", searchText)
            let quotePredicate = NSPredicate(format: "quote CONTAINS[c] %@", searchText)
            let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [authorPredicate, quotePredicate])
            request.predicate = orPredicate
        }
        do {
            self.isDataLoaded = true
            prompts = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    func addNewEntry() -> PromptEntity {
        let newPrompt = PromptEntity(context: PersistenceController.shared.container.viewContext)
        newPrompt.id = UUID()
        newPrompt.timestamp = Date()
        newPrompt.position = Int64(prompts.count == 0 ? 0 : prompts.count + 1)
        self.saveChanges()
        self.fetchEntries()
        
        return newPrompt
    }
    
    func updateEntry(_ entry: PromptEntity, author: String, quote: String) {
        entry.author = author
        entry.quote = quote
        self.sortEntries()
        self.saveChanges()
        self.fetchEntries()
    }
    
    func deleteEntry(_ entry: PromptEntity) {
        PersistenceController.shared.container.viewContext.delete(entry)
        self.sortEntries()
        self.saveChanges()
        self.fetchEntries()
    }
    
    func moveEntry(from oldIndex: IndexSet, to newIndex: Int) {
        // This guarantees that the edits are performed in the same thread as the CoreData context
        PersistenceController.shared.container.viewContext.perform {
            var revisedEntries: [PromptEntity] = self.prompts.map({$0})
            revisedEntries.move(fromOffsets: oldIndex, toOffset: newIndex)
            for reverseIndex in stride(from: revisedEntries.count-1, through: 0, by: -1) {
                revisedEntries[reverseIndex].position = Int64(reverseIndex)
            }
            self.saveChanges()
            self.fetchEntries()
        }
    }
    
    func sortEntries() {
        PersistenceController.shared.container.viewContext.perform {
            let revisedEntries: [PromptEntity] = self.prompts.map({$0})
            for reverseIndex in stride(from: revisedEntries.count-1, through: 0, by: -1) {
                revisedEntries[reverseIndex].position = Int64(reverseIndex)
            }
            self.saveChanges()
            self.fetchEntries()
        }
    }

    
    func deleteCoreData() {
        PersistenceController.shared.RemoveiCloudData() { (result) in
            if result {
                debugPrint("Core Data delete Sucess")
            } else {
                debugPrint("Core Data delete Fail")
            }
            self.fetchEntries()
        }
    }

    func discardChanges() {
        PersistenceController.shared.container.viewContext.rollback()
        self.fetchEntries()
    }
    
    func saveChanges() {
        PersistenceController.shared.saveContext() { error in
            guard error == nil else {
                print("An error occurred while saving: \(error!)")
                return
            }
        }
    }
}
