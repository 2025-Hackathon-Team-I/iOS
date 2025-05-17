//
//  CustomCompletionBnt.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/18/25.
//

import SwiftUI

struct CompletionButton: View {
    // 버튼 활성화 여부
    var isFormCompleted: Bool
    
    // 버튼 액션
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            // 폼이 완료되었을 때만 액션 실행
            if isFormCompleted {
                action()
            }
        }) {
            Text("완료")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color(hex: 0x36363F)) // 공통 글씨색
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isFormCompleted
                        ? Color(hex: 0x9DF2E3) // 완료 시 민트색 배경
                        : Color(hex: 0x676771) // 미완료 시 회색 배경
                )
                .cornerRadius(12) // 공통 cornerRadius
                .overlay(
                    // 미완료 상태일 때만 테두리 추가
                    !isFormCompleted ?
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: 0x8E8E93), lineWidth: 1)
                        : nil
                )
        }
        .disabled(!isFormCompleted) // 폼 미완료 시 버튼 비활성화
    }
}
