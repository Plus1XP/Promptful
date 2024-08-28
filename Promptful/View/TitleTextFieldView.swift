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
        TextField("Author...", text: $string, axis: .vertical)
            .font(.title.bold())
//            .submitLabel(.next)
            .focused($contentEditorInFocus)
//            .onChange(of: string, {
//                guard let newValueLastChar = string.last else { return }
//                if newValueLastChar == "\n" {
//                    string.removeLast()
//                    contentEditorInFocus = true
//                }
//            })
            .foregroundColor(.primary)
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .fill(Color.setFieldBackgroundColor(colorScheme: colorScheme))
            )
            .border(contentEditorInFocus ? colorScheme == .light ? .white : Color(UIColor.secondarySystemBackground) : .clear)
            .cornerRadius(12)
            .shadow(color: contentEditorInFocus ? colorScheme == .light ? .gray.opacity(0.4) : .white.opacity(0.4) : .clear, radius: 2)
    }
}

#Preview {
    TitleTextFieldView(string: .constant("This is a quote"))
}
