//
//  TravelDetailViewModel.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/18/25.
//

import Foundation
import Combine
import CoreLocation

class TravelDetailViewModel {
    // MARK: - Published Properties
    @Published var item: DetailedClothingItem?
    @Published var travelHistories: [TravelHistory] = []
    @Published var travelLocations: [TravelLocation] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // MARK: - Private Properties
    private let itemId: String
    private var cancellables = Set<AnyCancellable>()

    // 더미 데이터 딕셔너리
    private let dummyItems: [String: DetailedClothingItem] = [
        "item_1": DetailedClothingItem(
            id: "item_1",
            name: "베이지 치마",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%801.png",
            category: "하의",
            description: "클래식한 디자인의 베이지 미디 치마로, 겨울 시즌 다양한 스타일에 매치되어 사랑받았습니다. 총 3명의 사용자와 함께한 따뜻한 겨울 기록이 담겨 있습니다.",
            startDate: "2024-11-28",
            endDate: "2025-04-04",
            size: "S",
            tags: ["베이지치마", "겨울패션", "미디스커트"],
            usedDays: 172,
            currentLocation: "서울특별시 용산구 한강대로 23길 55, 아이파크몰 1층"
        ),
        "item_2": DetailedClothingItem(
            id: "item_2",
            name: "남색 린넨 원피스",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%802.png",
            category: "원피스",
            description: "여름과 겨울 사이의 계절에도 어울리는 남색 린넨 원피스로, 간결하면서도 멋스러운 무드를 자아냅니다.",
            startDate: "2024-11-20",
            endDate: "2025-02-26",
            size: "M",
            tags: ["린넨원피스", "남색룩", "간절기패션"],
            usedDays: 180,
            currentLocation: "서울특별시 마포구 양화로 45, 메세나폴리스몰 1층"
        ),
        "item_3": DetailedClothingItem(
            id: "item_3",
            name: "청색 카고바지",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%803.png",
            category: "하의",
            description: "실용적인 포켓과 활동성을 강조한 청색 카고바지입니다. 야외 활동과 데일리룩 모두에 잘 어울리는 아이템으로 총 3명의 여정을 함께했습니다.",
            startDate: "2024-10-05",
            endDate: "2025-01-30",
            size: "M",
            tags: ["카고바지", "스트릿룩", "청바지코디"],
            usedDays: 226,
            currentLocation: "서울특별시 강남구 테헤란로 201"
        ),
        "item_4": DetailedClothingItem(
            id: "item_4",
            name: "화이트 스퀘어 프릴 원피스",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%804.png",
            category: "원피스",
            description: "스퀘어넥과 프릴 디테일이 우아함을 더하는 원피스. 감성적인 분위기와 함께한 3번의 여정이 기록되어 있습니다.",
            startDate: "2024-09-15",
            endDate: "2024-12-13",
            size: "XS",
            tags: ["프릴원피스", "화이트룩", "로맨틱무드"],
            usedDays: 246,
            currentLocation: "서울특별시 성동구 왕십리로 115"
        ),
        "item_5": DetailedClothingItem(
            id: "item_5",
            name: "청셔츠",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%805.png",
            category: "상의",
            description: "클래식한 데님 셔츠, 다양한 겨울 코디에 활용됨",
            startDate: "2024-12-01",
            endDate: "2025-01-15",
            size: "M",
            tags: ["청셔츠", "겨울코디", "캐주얼룩"],
            usedDays: 168,
            currentLocation: "부산광역시 해운대구 우동 123"
        ),
        "item_6": DetailedClothingItem(
            id: "item_6",
            name: "레플리카",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%806.png",
            category: "상의",
            description: "독창적인 감성의 스트릿 셔츠. 겨울 시즌 트렌디한 착장에 어울림",
            startDate: "2024-11-20",
            endDate: "2025-04-10",
            size: "L",
            tags: ["레플리카", "스트릿룩", "겨울셔츠"],
            usedDays: 179,
            currentLocation: "서울특별시 성동구 서울숲길 55, 패션 편집샵 루트66"
        ),
        "item_7": DetailedClothingItem(
            id: "item_7",
            name: "흰색 멘투맨",
            imageURL: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%807.png",
            category: "상의",
            description: "베이직한 디자인의 흰색 멘투맨은 어떤 하의와도 잘 어울리는 활용도 높은 아이템입니다. 포근한 착용감 덕분에 일상 속 다양한 순간에 함께 했습니다.",
            startDate: "2024-11-10",
            endDate: "2025-05-18",
            size: "L",
            tags: ["기본템", "흰색맨투맨", "데일리룩"],
            usedDays: 190,
            currentLocation: "서울특별시 서대문구 연세로 50"
        )
    ]

    // 여행 기록 더미 데이터
    private let dummyHistories: [String: [TravelHistory]] = [
        "item_1": [
            TravelHistory(id: "1", ownerName: "승환킴", startDate: "2024-11-28", endDate: "2025-01-13"),
            TravelHistory(id: "2", ownerName: "선혜선", startDate: "2025-01-14", endDate: "2025-03-01"),
            TravelHistory(id: "3", ownerName: "사랑킴", startDate: "2025-03-02", endDate: "2025-05-18")
        ],
        "item_2": [
            TravelHistory(id: "1", ownerName: "서연박", startDate: "2024-11-20", endDate: "2025-01-03"),
            TravelHistory(id: "2", ownerName: "민준최", startDate: "2025-01-04", endDate: "2025-02-17"),
            TravelHistory(id: "3", ownerName: "나영김", startDate: "2025-02-18", endDate: "2025-05-18")
        ],
        "item_3": [
            TravelHistory(id: "1", ownerName: "민석최", startDate: "2024-10-05", endDate: "2024-12-05"),
            TravelHistory(id: "2", ownerName: "수빈이", startDate: "2024-12-06", endDate: "2025-02-04"),
            TravelHistory(id: "3", ownerName: "지후박", startDate: "2025-02-05", endDate: "2025-05-18")
        ],
        "item_4": [
            TravelHistory(id: "1", ownerName: "나연이", startDate: "2024-09-15", endDate: "2024-11-02"),
            TravelHistory(id: "2", ownerName: "채린장", startDate: "2024-11-03", endDate: "2024-12-22"),
            TravelHistory(id: "3", ownerName: "예진이", startDate: "2024-12-23", endDate: "2025-05-18")
        ],
        "item_5": [
            TravelHistory(id: "1", ownerName: "승환킴", startDate: "2024-12-01", endDate: "2025-01-15", note: "첫 착용"),
            TravelHistory(id: "2", ownerName: "선혜신", startDate: "2025-01-15", endDate: "2025-03-10", note: "겨울 부산 여행"),
            TravelHistory(id: "3", ownerName: "사랑킴", startDate: "2025-01-04", endDate: "2025-05-18", note: "신년 모임")
        ],
        "item_6": [
            TravelHistory(id: "1", ownerName: "승환킴", startDate: "2024-11-20", endDate: "2024-12-03", note: "스트릿 패션 행사 참가 (홍대)"),
            TravelHistory(id: "2", ownerName: "선혜신", startDate: "2024-12-03", endDate: "2024-12-23", note: "촬영 의상 대여 (인천 송도)"),
            TravelHistory(id: "3", ownerName: "사랑킴", startDate: "2024-12-23", endDate: "2025-05-18", note: "크리스마스 파티 착용 (수원 광교)")
        ],
        "item_7": [
            TravelHistory(id: "1", ownerName: "준호이", startDate: "2024-11-10", endDate: "2025-01-17"),
            TravelHistory(id: "2", ownerName: "세진최", startDate: "2025-01-18", endDate: "2025-03-25"),
            TravelHistory(id: "3", ownerName: "수아김", startDate: "2025-03-26", endDate: "2025-05-18")
        ]
    ]

    // 여행 위치 더미 데이터
    private let dummyLocations: [String: [TravelLocation]] = [
        "item_1": [
            TravelLocation(id: "1", name: "용산", latitude: 37.529404, longitude: 126.964276),
            TravelLocation(id: "2", name: "강남", latitude: 37.503837, longitude: 127.044961),
            TravelLocation(id: "3", name: "홍대", latitude: 37.556817, longitude: 126.925138)
        ],
        "item_2": [
            TravelLocation(id: "1", name: "마포", latitude: 37.556593, longitude: 126.919433),
            TravelLocation(id: "2", name: "신촌", latitude: 37.559931, longitude: 126.942739),
            TravelLocation(id: "3", name: "이태원", latitude: 37.534709, longitude: 126.994263)
        ],
        "item_3": [
            TravelLocation(id: "1", name: "강남", latitude: 37.501274, longitude: 127.039585),
            TravelLocation(id: "2", name: "삼성", latitude: 37.508545, longitude: 127.060698),
            TravelLocation(id: "3", name: "선릉", latitude: 37.504513, longitude: 127.048923)
        ],
        "item_4": [
            TravelLocation(id: "1", name: "성수", latitude: 37.561016, longitude: 127.037682),
            TravelLocation(id: "2", name: "왕십리", latitude: 37.565713, longitude: 127.035947),
            TravelLocation(id: "3", name: "서울숲", latitude: 37.543601, longitude: 127.044477)
        ],
        "item_5": [
            TravelLocation(id: "1", name: "강남", latitude: 37.5010, longitude: 127.0396),
            TravelLocation(id: "2", name: "삼성", latitude: 37.5086, longitude: 127.0607),
            TravelLocation(id: "3", name: "해운대", latitude: 35.1590, longitude: 129.1601)
        ],
        "item_6": [
            TravelLocation(id: "1", name: "송도", latitude: 37.386052, longitude: 126.643629),
            TravelLocation(id: "2", name: "홍대", latitude: 37.556820, longitude: 126.925130),
            TravelLocation(id: "3", name: "광교", latitude: 37.294960, longitude: 127.047546)
        ],
        "item_7": [
            TravelLocation(id: "1", name: "신촌", latitude: 37.565784, longitude: 126.938572),
            TravelLocation(id: "2", name: "홍대", latitude: 37.556820, longitude: 126.925130),
            TravelLocation(id: "3", name: "연남동", latitude: 37.562148, longitude: 126.925575)
        ]
    ]

    // MARK: - Initialization
    init(itemId: String) {
        self.itemId = itemId
    }

    // MARK: - Public Methods
    func loadData() {
        isLoading = true
        errorMessage = nil

        // 더미 데이터 지연 로드 (실제 네트워크 통신처럼 보이게 하기 위함)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            // 더미 데이터 로드
            if let item = self.dummyItems[self.itemId],
               let histories = self.dummyHistories[self.itemId],
               let locations = self.dummyLocations[self.itemId] {

                self.item = item
                self.travelHistories = histories
                self.travelLocations = locations
                self.isLoading = false
            } else {
                self.errorMessage = "아이템을 찾을 수 없습니다."
                self.isLoading = false
            }
        }
    }
}

// MARK: - Data Models
struct DetailedClothingItem {
    let id: String
    let name: String
    let imageURL: String
    let category: String
    let description: String
    let startDate: String
    let endDate: String
    let size: String
    let tags: [String]
    let usedDays: Int
    let currentLocation: String
}

struct TravelHistory {
    let id: String
    let ownerName: String
    let startDate: String
    let endDate: String
    var note: String? = nil
}

struct TravelLocation {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}
