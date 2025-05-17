//
//  LoginView.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("디지털 옷장")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 50)

            Button(action: {
                viewModel.signIn()
            }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Apple로 로그인")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
//            .previewDevice("iPhone 14 Pro")
    }
}
