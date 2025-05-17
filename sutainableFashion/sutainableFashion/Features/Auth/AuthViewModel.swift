//
//  AuthViewModel.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import AuthenticationServices
import SwiftUI

// MARK: - AppleOAtuthViewModel

class AuthViewModel: NSObject, ObservableObject {
    @Published var givenName: String = ""
    @Published var errorMessage: String = ""
    @Published var oauthUserData = AuthModel()

    func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func signOut() {
        // 로그아웃 로직 (필요에 따라 구현)
    }
}

// MARK: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    /// Apple ID 연동 성공 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let idToken = appleIDCredential.identityToken!

            oauthUserData.oauthId = userIdentifier
            oauthUserData.idToken = String(data: idToken, encoding: .utf8) ?? ""

            if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
                self.givenName = "\(givenName) \(familyName)"
            }
        default:
            break
        }
    }

    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("No window found")
        }
        return window
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        errorMessage = "Authorization failed: \(error.localizedDescription)"
    }
}
