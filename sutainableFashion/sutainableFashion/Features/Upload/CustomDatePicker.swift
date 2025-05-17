//
//  CustomDatePicker.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/18/25.
//

import SwiftUI

struct CustomDatePicker: View {
    @State private var selectedYear = 2000
    @State private var selectedMonth = 0
    @State private var selectedDay = 0
    
    // 선택 가능한 년도 범위 (예: 1950-현재)
    let years = Array(1950...2025)
    
    // 월 배열 (0~11)
    let months = Array(0...11)
    
    // 일 배열 (0~30)
    var days: [Int] {
        // 선택한 월과 년도에 따라 일 계산
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = selectedYear
        dateComponents.month = selectedMonth + 1 // 0부터 시작하므로 +1
        
        // 해당 월의 일수 계산
        guard let date = calendar.date(from: dateComponents),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return Array(0...30) // 기본값
        }
        
        return Array(0..<range.count)
    }
    
    var body: some View {
        HStack(spacing: 30) {
            // 년도 선택
            DateDropdown(
                title: "\(selectedYear)년",
                selection: $selectedYear,
                options: years,
                formatOption: { "\($0)년" }
            )
            
            // 월 선택
            DateDropdown(
                title: "\(String(format: "%02d", selectedMonth))월",
                selection: $selectedMonth,
                options: months,
                formatOption: { "\(String(format: "%02d", $0))월" }
            )
            
            // 일 선택
            DateDropdown(
                title: "\(String(format: "%02d", selectedDay))일",
                selection: $selectedDay,
                options: days,
                formatOption: { "\(String(format: "%02d", $0))일" }
            )
        }
        .padding()
    }
}

// 재사용 가능한 드롭다운 컴포넌트
struct DateDropdown<T: Hashable>: View {
    var title: String
    @Binding var selection: T
    var options: [T]
    var formatOption: (T) -> String
    
    var body: some View {
        Menu {
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(formatOption(option)).tag(option)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
}
