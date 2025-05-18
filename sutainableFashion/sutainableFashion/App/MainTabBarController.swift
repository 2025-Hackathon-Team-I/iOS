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
        let closetTab = UINavigationController(rootViewController: closetVC)
        closetTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "closet") ?? UIImage(), selectedImage: UIImage(named: "closet.fill") ?? UIImage())
        closetTab.tabBarItem.imageInsets = UIEdgeInsets(top: 20.5, left: 0, bottom: -20.5, right: 0)

        // 2. 업로드 탭
        let uploadViewModel = UploadViewModel()
        let uploadView = UploadView(viewModel: uploadViewModel)
        let uploadVC = UIHostingController(rootView: uploadView)
        uploadVC.title = "업로드"
        let uploadTab = UINavigationController(rootViewController: uploadVC)
        uploadTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "upload") ?? UIImage(), selectedImage: UIImage(named: "upload.fill") ?? UIImage())
        uploadTab.tabBarItem.imageInsets = UIEdgeInsets(top: 20.5, left: 0, bottom: -20.5, right: 0)

        // 3. 트래블 탭
        let travelHomeViewModel = TravelHomeViewModel()
        let travelHomeView = TravelHomeView(viewModel: travelHomeViewModel)
        let travelHomeViewVC = UIHostingController(rootView: travelHomeView)
        let travelHomeTab = UINavigationController(rootViewController: travelHomeViewVC)
        travelHomeTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "travel") ?? UIImage(), selectedImage: UIImage(named: "travel.fill") ?? UIImage())
        travelHomeTab.tabBarItem.imageInsets = UIEdgeInsets(top: 20.5, left: 0, bottom: -20.5, right: 0)

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
