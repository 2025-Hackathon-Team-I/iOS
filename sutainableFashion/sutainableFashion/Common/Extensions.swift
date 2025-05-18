//
//  Extensions.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import SwiftUI
import UIKit

extension Color {
    // 헥사 코드 색상 사용
    //
    // 방식 - 색상 코드 F0F0F0일 때
    // 0x 붙이고 hex에 넣기
    //   ex. Color(hex: 0xF0F0F0)
    // 투명도 주고 싶을 때
    //   ex. Color(hex: 0xF0F0F0, alpha: 0.3)
    //       Color(hex: 0xF0F0F0).opacity(0.3)
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
