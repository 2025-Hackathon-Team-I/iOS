//
//  UploadView.swift
//  sutainableFashion
//
//  Created by 최승희 on 5/17/25.
//

import SwiftUI
import PhotosUI

struct UploadView: View {
    @ObservedObject var viewModel: UploadViewModel
    
    // 아이템 종류
    let items = ["상의", "하의", "신발", "기타"]
    // 사이즈
    let sizes = ["XXXL", "XXL", "XL", "L", "M", "S", "XS", "XXS"]
    
    // 사진 업로드
    @State private var uploadedImages: [UIImage] = []
    
    // 텍스트필드
    @State var title: String = ""
    @State var content: String = ""
    @State var Hashtag: String = ""
    @State var date = Date()
    
    // 토글
    @State var showGreeting = false
    
    var body: some View {
        ZStack {
            Color(hex: 0x202020)
                .ignoresSafeArea() // 배경을 전체 화면에 깔기
            ScrollView {
                VStack(alignment: .leading) {
                    SectionTitle(title: "아이템 종류 선택")
                    // 아이템 버튼
                    HStack(spacing: 5) {
                        ForEach(items, id: \.self) { item in
                            ItemsButton(title: item)
                        }
                    } // HStack
                    
                    // 사진 업로드
                    Text("최대 다섯 장까지 가능해요")
                        .font(.custom("Pretendard Variable", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: 0xFFFFFF))
                    // 사진 추가
                    PhotoUploaderView(images: $uploadedImages)

                    // 텍스트 필드
                    TextField("Title Box", text: $title)
                        .padding()
                        .foregroundStyle(Color(hex: 0xC7C7CC))
                        .background(Color(hex: 0x36363F))
                        .cornerRadius(8)
                    TextEditor(text: $content)
                        .cornerRadius(8)
                        .frame(height: 120)
                    
                    // 사이즈
                    SectionTitle(title: "사이즈를 선택해주세요")
                    // 사이즈 버튼
                    HStack{
                        ForEach(0...3, id: \.self) { idx in
                            SizesButton(title: sizes[idx])
                        }
                    } // HStack
                    HStack {
                        ForEach(4..<sizes.count, id: \.self) { idx in
                            SizesButton(title: sizes[idx])
                        }
                    } // HStack
                    
                    // 해시태그
                    Text("해시태그를 추가해주세요")
                        .font(.custom("Pretendard Variable", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: 0xFFFFFF))
                    // 해시태그 텍스트필드
                    TextField("Title Box", text: $Hashtag)
                    
                    // 날짜
                    SectionTitle(title: "사용한 날짜를 입력해주세요")
                    // DataPicker
                    DatePicker("", selection: $date)
                    
                    // 판매 여부
                    Toggle("판매를 희망하시나요?", isOn: $showGreeting)
                        .font(.custom("Pretendard Variable", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: 0xFFFFFF))
                } // VStack
                .padding(10)
            } // ScrollView
        } // ZStack
    } // body
        
}

// 글씨 스타일
struct SectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.custom("Pretendard Variable", size: 20))
            .fontWeight(.bold)
            .foregroundStyle(Color(hex: 0xFFFFFF))
    }
}

// 아이템 버튼
struct ItemsButton: View {
    let title: String

    var body: some View {
        Button(action: {
            print(title)
        }) {
            Text(title)
                .font(.custom("Pretendard Variable", size: 14))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(Color(hex: 0x36363F))
                .foregroundColor(Color(hex: 0x8E8E93))
                .cornerRadius(6)
        }
    }
}

// 사이즈 버튼
struct SizesButton: View {
    let title: String

    var body: some View {
        Button(action: {
            print(title)
        }) {
            Text(title)
                .font(.custom("Pretendard Variable", size: 16))
                .frame(width: 60, height: 40)
                .background(Color(hex: 0x36363F))
                .foregroundColor(Color(hex: 0x8E8E93))
                .cornerRadius(6)
        }
    }
}

// 사진 업로드
struct PhotoUploaderView: View {
    @Binding var images: [UIImage]
    @State private var selectedItems: [PhotosPickerItem] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(images.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 124, height: 118)
                                .clipped()
                                .cornerRadius(8)

                            Button(action: {
                                images.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .offset(x: -5, y: 5)
                        }
                    }

                    if images.count < 5 {
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 5 - images.count,
                            matching: .images
                        ) {
                            Text("+")
                                .font(.system(size: 50))
                                .fontWeight(.light)
                                .frame(width: 124, height: 118)
                                .background(Color(hex: 0x36363F))
                                .foregroundStyle(Color(hex: 0xC7C7CC))
                                .cornerRadius(8)
                        }
                        .onChange(of: selectedItems) { newItems in
                            Task {
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        images.append(uiImage)
                                    }
                                }
                                selectedItems = []
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Contents_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(viewModel: UploadViewModel())
    }
}
