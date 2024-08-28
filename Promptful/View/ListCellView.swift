//
//  ListCellView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct ListCellView: View {
    @Environment(\.colorScheme) private var colorScheme
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
                        Text(prompt.quote ?? "No context available")
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
                HStack() {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(prompt.author ?? "Unkown Author")
                            .lineLimit(1)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 15)
        .background(
            Rectangle()
                .fill(Color.setFieldBackgroundColor(colorScheme: colorScheme).opacity(1))
                .cornerRadius(10.0)
                .padding([.top, .bottom], 3)
        )
    }
}

#Preview {
    ListCellView(prompt: PersistenceController.shared.samplePrompt)
}
