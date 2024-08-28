//
//  PersistenceController.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import Foundation

extension PersistenceController {
    var samplePrompt: PromptEntity {
        let context = PersistenceController.preview.container.viewContext
        let prompt = PromptEntity(context: context)
        prompt.id = UUID()
        prompt.timestamp = Date()
        prompt.position = 0
        prompt.author = "Oscar Wilde"
        prompt.quote = "Youth is wasted on the young."
        return prompt
    }
}
