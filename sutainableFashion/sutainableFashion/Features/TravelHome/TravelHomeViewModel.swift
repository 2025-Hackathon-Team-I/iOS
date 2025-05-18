//
//  TravelHomeViewModel.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/18/25.
//

import Foundation
import SwiftUI
import CoreLocation

class TravelHomeViewModel: ObservableObject {
    // 샘플 아이템 데이터
    let sampleItems: [TravelItem] = [
        TravelItem(
            id: "item_1",
            name: "베이지 치마",
            location: "서울특별시 용산구 한강대로 23길",
            usedDays: 172,
            usersCount: 3,
            imageUrl: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%801.png",
            coordinate: CLLocationCoordinate2D(latitude: 37.529404, longitude: 126.964276)
        ),
        TravelItem(
            id: "item_2",
            name: "남색 린넨 원피스",
            location: "서울특별시 마포구 양화로 45",
            usedDays: 180,
            usersCount: 3,
            imageUrl: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%802.png",
            coordinate: CLLocationCoordinate2D(latitude: 37.556593, longitude: 126.919433)
        ),
        TravelItem(
            id: "item_3",
            name: "청색 카고바지",
            location: "서울특별시 강남구 테헤란로 201",
            usedDays: 226,
            usersCount: 3,
            imageUrl: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%803.png",
            coordinate: CLLocationCoordinate2D(latitude: 37.501274, longitude: 127.039585)
        ),
        TravelItem(
            id: "item_4",
            name: "화이트 스퀘어 프릴 원피스",
            location: "서울특별시 성동구 왕십리로 115",
            usedDays: 246,
            usersCount: 3,
            imageUrl: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%804.png",
            coordinate: CLLocationCoordinate2D(latitude: 37.561016, longitude: 127.037682)
        ),
        TravelItem(
            id: "item_5",
            name: "청셔츠",
            location: "서울시 강남구 테헤란로 123",
            usedDays: 168,
            usersCount: 3,
            imageUrl: "",
            coordinate: CLLocationCoordinate2D(latitude: 37.5010, longitude: 127.0396)
        ),
        TravelItem(
            id: "item_6",
            name: "레플리카",
            location: "인천광역시 연수구 아트센터대로 87",
            usedDays: 179,
            usersCount: 3,
            imageUrl: "",
            coordinate: CLLocationCoordinate2D(latitude: 37.386052, longitude: 126.643629)
        ),
        TravelItem(
            id: "item_7",
            name: "흰색 멘투맨",
            location: "서울특별시 서대문구 연세로 50",
            usedDays: 190,
            usersCount: 3,
            imageUrl: "https://test-gitget-deploy-bucket.s3.ap-southeast-2.amazonaws.com/test/%EC%9D%B4%EB%AF%B8%EC%A7%807.png",
            coordinate: CLLocationCoordinate2D(latitude: 37.565784, longitude: 126.938572)
        )
    ]

    // 네비게이션 헬퍼에 있는 메서드 직접 구현
    func navigateToDetail(for itemId: String) {
        guard let tabBarController = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController,
              let travelTab = tabBarController.viewControllers?[2] as? UINavigationController else {
            return
        }

        let viewModel = TravelDetailViewModel(itemId: itemId)
        let detailVC = TravelDetailViewController(viewModel: viewModel)

        // 메인 스레드에서 화면 전환
        DispatchQueue.main.async {
            travelTab.pushViewController(detailVC, animated: true)
        }
    }

    // 지도에 표시할 모든 아이템 위치
    func getMapLocations() -> [Location] {
        return sampleItems.map { item in
            Location(
                name: item.name,
                coordinate: item.coordinate
            )
        }
    }
}

// 트래블 아이템 모델
struct TravelItem: Identifiable {
    let id: String
    let name: String
    let location: String
    let usedDays: Int
    let usersCount: Int
    let imageUrl: String
    let coordinate: CLLocationCoordinate2D
}

//import Foundation
//import SwiftUI
//
//class TravelHomeViewModel: ObservableObject {
//    // 샘플 아이템 데이터
//    let sampleItems: [TravelItem] = [
//        TravelItem(id: "item_1", name: "블랙 티셔츠", location: "서울 특별시 관악구", usedDays: 120, usersCount: 3),
//        TravelItem(id: "item_2", name: "청바지", location: "부산 해운대구 우동", usedDays: 90, usersCount: 2)
//    ]
//
//    // 네비게이션 헬퍼에 있는 메서드 직접 구현
//    func navigateToDetail(for itemId: String) {
//        guard let tabBarController = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController,
//              let travelTab = tabBarController.viewControllers?[2] as? UINavigationController else {
//            return
//        }
//
//        let viewModel = TravelDetailViewModel(itemId: itemId)
//        let detailVC = TravelDetailViewController(viewModel: viewModel)
//
//        // 메인 스레드에서 화면 전환
//        DispatchQueue.main.async {
//            travelTab.pushViewController(detailVC, animated: true)
//        }
//    }
//}
//
//// 트래블 아이템 모델
//struct TravelItem: Identifiable {
//    let id: String
//    let name: String
//    let location: String
//    let usedDays: Int
//    let usersCount: Int
//}
