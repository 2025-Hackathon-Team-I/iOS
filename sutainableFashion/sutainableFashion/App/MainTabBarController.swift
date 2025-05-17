//
//  MainTabBarController.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        // 1. 내 옷장 탭
        let closetVC = UIViewController()
        closetVC.title = "내 옷장"
        let closetTab = UINavigationController(rootViewController: closetVC)
        closetTab.tabBarItem = UITabBarItem(title: "내 옷장", image: UIImage(systemName: "tshirt"), tag: 0)

        // 2. 소셜 탭
        let socialVC = UIViewController()
        socialVC.title = "소셜"
        let socialTab = UINavigationController(rootViewController: socialVC)
        socialTab.tabBarItem = UITabBarItem(title: "소셜", image: UIImage(systemName: "person.3"), tag: 1)

        // 3. 히스토리 탭
        let historyVC = UIViewController()
        historyVC.title = "히스토리"
        let historyTab = UINavigationController(rootViewController: historyVC)
        historyTab.tabBarItem = UITabBarItem(title: "히스토리", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 2)

        // 4. 마이페이지 탭
        let profileVC = UIViewController()
        profileVC.title = "마이페이지"
        let profileTab = UINavigationController(rootViewController: profileVC)
        profileTab.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)

        // 5. 업로드 탭
        let uploadViewModel = UploadViewModel()
        let uploadView = UploadView(viewModel: uploadViewModel)
        let uploadVC = UIHostingController(rootView: uploadView)
        uploadVC.title = "업로드"
        let uploadTab = UINavigationController(rootViewController: uploadVC)
        uploadTab.tabBarItem = UITabBarItem(title: "업로드", image: UIImage(systemName: "person.circle"), tag: 4)

        // 모든 탭 설정
        viewControllers = [closetTab, socialTab, historyTab, profileTab, uploadTab]
    }
}
