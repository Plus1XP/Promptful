//
//  TitleTextFieldView.swift
//  Promptful
//
//  Created by nabbit on 28/08/2024.
//

import SwiftUI

struct TitleTextFieldView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var string: String
    @FocusState private var contentEditorInFocus: Bool

    var body: some View {
        TextField("Who is the author?...", text: $string, axis: .vertical)
            .font(.title.bold())
            .focused($contentEditorInFocus)
            .foregroundColor(.primary)
            .padding(5)
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .fill(Color.background)
            )
            .border(self.contentEditorInFocus ? self.colorScheme == .light ? .white : Color(UIColor.secondarySystemBackground) : .clear)
            .cornerRadius(12)
            .shadow(color: self.contentEditorInFocus ? self.colorScheme == .light ? .gray.opacity(0.4) : .white.opacity(0.4) : .clear, radius: 2)
    }
}

#Preview {
    TitleTextFieldView(string: .constant("This is a quote"))
}
