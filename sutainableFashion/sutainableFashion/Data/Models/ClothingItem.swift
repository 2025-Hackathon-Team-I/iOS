//
//  ClothingItem.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import Foundation

// MARK: - ClothingItem 모델
struct ClothingItem: Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: String
    let category: String
    let description: String
    let startDate: String
    let endDate: String
    let size: String
    let tags: [String]
    var isForSale: Bool = false

    // MARK: - Hashable 프로토콜 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - Equatable 프로토콜 구현
    static func == (lhs: ClothingItem, rhs: ClothingItem) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - 기본값을 가진 생성자
    init(id: String,
         name: String,
         imageURL: String,
         category: String,
         description: String,
         startDate: String,
         endDate: String,
         size: String,
         tags: [String],
         isForSale: Bool = false) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.category = category
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.size = size
        self.tags = tags
        self.isForSale = isForSale
    }
}

// MARK: - Codable 확장 (네트워크 통신용)
extension ClothingItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
        case category
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case size
        case tags
        case isForSale = "is_for_sale"
    }
}

// MARK: - 카테고리 타입
extension ClothingItem {
    enum Category: String, CaseIterable {
        case tops = "상의"
        case bottoms = "하의"
        case shoes = "신발"
        case etc = "기타"

        static var all: [String] {
            return ["전체"] + Self.allCases.map { $0.rawValue }
        }
    }
}

//// MARK: - 더미 데이터 생성 (개발 및 테스트용)
//extension ClothingItem {
//    static func getDummyItems() -> [ClothingItem] {
//        return [
//            ClothingItem(
//                id: "1",
//                name: "블랙 티셔츠",
//                imageURL: "",
//                category: Category.tops.rawValue,
//                description: "기본 블랙 티셔츠입니다.",
//                startDate: "2025. 01. 01",
//                endDate: "2025. 05. 01",
//                size: "L",
//                tags: ["기본", "블랙", "티셔츠", "데일리"]
//            ),
//            ClothingItem(
//                id: "2",
//                name: "청바지",
//                imageURL: "",
//                category: Category.bottoms.rawValue,
//                description: "데님 청바지입니다.",
//                startDate: "2025. 02. 01",
//                endDate: "2025. 06. 01",
//                size: "32",
//                tags: ["데님", "청바지", "캐주얼"]
//            ),
//            ClothingItem(
//                id: "3",
//                name: "흰색 스니커즈",
//                imageURL: "",
//                category: Category.shoes.rawValue,
//                description: "흰색 캔버스 스니커즈입니다.",
//                startDate: "2025. 03. 01",
//                endDate: "2025. 07. 01",
//                size: "265",
//                tags: ["스니커즈", "화이트", "캔버스"]
//            ),
//            ClothingItem(
//                id: "4",
//                name: "블랙 맨투맨",
//                imageURL: "",
//                category: Category.tops.rawValue,
//                description: "검정색 맨투맨 스웨트셔츠입니다.",
//                startDate: "2025. 01. 15",
//                endDate: "2025. 05. 15",
//                size: "XL",
//                tags: ["맨투맨", "블랙", "캐주얼"]
//            ),
//            ClothingItem(
//                id: "5",
//                name: "카고 팬츠",
//                imageURL: "",
//                category: Category.bottoms.rawValue,
//                description: "카키색 카고 팬츠입니다.",
//                startDate: "2025. 02. 15",
//                endDate: "2025. 06. 15",
//                size: "30",
//                tags: ["카고", "팬츠", "카키"]
//            ),
//            ClothingItem(
//                id: "6",
//                name: "검정 모자",
//                imageURL: "",
//                category: Category.etc.rawValue,
//                description: "블랙 베이스볼 캡입니다.",
//                startDate: "2025. 03. 15",
//                endDate: "2025. 07. 15",
//                size: "FREE",
//                tags: ["모자", "블랙", "캡"]
//            )
//        ]
//    }
//}
