//
//  LoginView.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false

    func login() {

        // 로그인 성공 처리
        self.isLoggedIn = true

        // 로그인 성공 알림 전송
        NotificationCenter.default.post(name: NSNotification.Name("LoginSuccessful"), object: nil)
    }
}
