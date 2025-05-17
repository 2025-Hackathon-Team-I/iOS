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
        changeRadius()
    }

    private func setupTabs() {
        // 1. 내 옷장 탭
        let closetVC = MyClosetViewController()
        closetVC.title = "내 옷장"
        let closetTab = UINavigationController(rootViewController: closetVC)
        closetTab.tabBarItem = UITabBarItem(title: "내 옷장", image: UIImage(systemName: "tshirt"), tag: 0)
        
        // 2. 업로드 탭
        let uploadViewModel = UploadViewModel()
        let uploadView = UploadView(viewModel: uploadViewModel)
        let uploadVC = UIHostingController(rootView: uploadView)
        uploadVC.title = "업로드"
        let uploadTab = UINavigationController(rootViewController: uploadVC)
        uploadTab.tabBarItem = UITabBarItem(title: "업로드", image: UIImage(systemName: "person.circle"), tag: 1)

        // 3. 트래블 탭
        let travelHomeViewModel = TravelHomeViewModel()
        let travelHomeView = TravelHomeView(viewModel: travelHomeViewModel)
        let travelHomeViewVC = UIHostingController(rootView: travelHomeView)
        let travelHomeTab = UINavigationController(rootViewController: travelHomeViewVC)
        travelHomeTab.tabBarItem = UITabBarItem(title: "트래블", image: UIImage(systemName: "person.circle"), tag: 2)

        // 모든 탭 설정
        viewControllers = [closetTab, uploadTab, travelHomeTab]
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         var tabFrame = self.tabBar.frame
         tabFrame.size.height = 68
         tabFrame.origin.y = self.view.frame.size.height - 68
         self.tabBar.frame = tabFrame
         self.tabBar.clipsToBounds = true
         self.tabBar.itemPositioning = .centered
     }

     func changeRadius() {
         self.tabBar.layer.cornerRadius = 16
         self.tabBar.layer.masksToBounds = true
//         self.tabBar.layer.backgroundColor = UIColor(hex: "#36363F")
         self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
     }
}
