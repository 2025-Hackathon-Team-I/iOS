//
//  NavigationHelper.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/18/25.
//

import UIKit
import SwiftUI

class NavigationHelper {
    static let shared = NavigationHelper()

    // 탭바에서 트래블 탭의 네비게이션 컨트롤러를 가져오는 메서드
    func getTravelNavigationController() -> UINavigationController? {
        guard let tabBarController = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController,
              let travelTab = tabBarController.viewControllers?[2] as? UINavigationController else {
            return nil
        }
        return travelTab
    }

    // 트래블 상세 화면으로 이동하는 메서드
    func navigateToTravelDetail(itemId: String) {
        guard let navigationController = getTravelNavigationController() else { return }

        let viewModel = TravelDetailViewModel(itemId: itemId)
        let detailVC = TravelDetailViewController(viewModel: viewModel)

        // 메인 스레드에서 화면 전환
        DispatchQueue.main.async {
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
