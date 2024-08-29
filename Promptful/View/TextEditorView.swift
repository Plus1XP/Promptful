//
//  TextEditorView.swift
//  Promptful
//
//  Created by nabbit on 27/08/2024.
//

import SwiftUI

struct TextEditorView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var string: String
    @State var textEditorHeight : CGFloat = 20
    @FocusState private var contentEditorInFocus: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(self.string)
                .foregroundColor(.clear)
                .padding(10)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            TextEditor(text: $string)
                .focused($contentEditorInFocus)
                .border(.clear)
            if self.string.isEmpty {
                Text("What did they say?...")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .disabled(true)
                    .opacity(0.6)
                    .padding([.top, .leading], 4)
            }
        }
        .onPreferenceChange(ViewHeightKey.self) { self.textEditorHeight = $0 }
        .foregroundColor(.primary)
        .background(
            RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            )
            .fill(Color.setFieldBackgroundColor(colorScheme: self.colorScheme))
        )
        .border(self.contentEditorInFocus ? self.colorScheme == .light ? .white : Color(UIColor.secondarySystemBackground) : .clear)
        .cornerRadius(12)
        .shadow(color: self.contentEditorInFocus ? self.colorScheme == .light ? .gray.opacity(0.4) : .white.opacity(0.4) : .clear, radius: 2)
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

#Preview {
    TextEditorView(string: .constant("This is a quote"))
}
