//
//  CustomHashtag.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/18/25.
//

import SwiftUI

struct HashtagInputView: View {
    @Binding var hashtags: [String]
    @State private var currentText: String = ""

    var body: some View {
        WrapHStack(spacing: 8) {
            ForEach(hashtags, id: \.self) { tag in
                HStack(spacing: 5) {
                    Text("#\(tag)")
                        .foregroundColor(.white)
                    Button(action: {
                        hashtags.removeAll { $0 == tag }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(hex: 0x4A4A4A))
                .cornerRadius(12)
            }

            // ✅ 문제 해결: TextField가 보이도록 padding/배경 설정
            TextField("해시태그 입력", text: $currentText)
                .onChange(of: currentText) { newValue in
                    if newValue.last == " " {
                        addHashtag()
                    }
                }
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(hex: 0x36363F))
                .foregroundColor(Color(hex: 0x8E8E93))
                .cornerRadius(12)
                .frame(minWidth: 60) // ✅ 최소 너비 줘야 보임
        }
        .padding()
        .background(Color(hex: 0x1C1C1E))
        .cornerRadius(10)
    }

    private func addHashtag() {
        let trimmed = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty && !hashtags.contains(trimmed) else {
            currentText = ""
            return
        }
        hashtags.append(trimmed)
        currentText = ""
    }
}

struct WrapHStack<Content: View>: View {
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: () -> Content

    init(spacing: CGFloat = 8,
         alignment: HorizontalAlignment = .leading,
         @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        FlowLayout(spacing: spacing, alignment: alignment, content: content)
    }
}

struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            content()
                .fixedSize()
                .alignmentGuide(.leading) { d in
                    if (abs(width - d.width) > geometry.size.width) {
                        width = 0
                        height -= d.height + spacing
                    }
                    let result = width
                    width -= d.width + spacing
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    return result
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
