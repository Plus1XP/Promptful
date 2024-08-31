//
//  ListCellView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct ListCellView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var promptStore: PromptStore
    var prompt: PromptEntity
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    VStack {
                        HStack(alignment: .top) {
                            Image(systemName: "quote.opening")
                        }
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.prompt.quote ?? "No context available")
                            .lineLimit(3)
                    }
                    Spacer()
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            Image(systemName: "quote.closing")
                        }
                    }
                }
                .padding(.bottom, 10)
                HStack() {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.prompt.author ?? "Unkown Author")
                            .lineLimit(1)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding([.top], 15)
        .padding([.leading, .trailing], 10)
        .padding([.bottom], 15)
        .background(
            Rectangle()
                .fill(Color.setFieldBackgroundColor(colorScheme: self.colorScheme).opacity(1))
                .cornerRadius(10.0)
                .padding([.top, .bottom], 3)
        )
    }
}

#Preview {
    ListCellView(prompt: PersistenceController.shared.samplePrompt)
        .environmentObject(PromptStore())
}
