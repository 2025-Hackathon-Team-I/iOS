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
    @State private var selectedItem: String? = nil
    
    // 사진 업로드
    @State private var uploadedImages: [UIImage] = []
    
    // 텍스트필드
    @State var title: String = ""
    @State var content: String = ""
    
    // 해시태그
    @State private var hashtags: [String] = []
    @State var date = Date()
    
    // 사이즈
    let sizes = ["XXXL", "XXL", "XL", "L", "M", "S", "XS", "XXS"]
    @State private var selectedSize: String? = nil
    
    // 토글
    @State var isForSale = false
    
    // 폼 완료 여부 계산
    private var isFormCompleted: Bool {
        // 1. 아이템 종류가 선택되어 있는지
        let hasSelectedItem = selectedItem != nil
        
        // 2. 사진이 하나 이상 업로드 되었는지
        let hasUploadedImage = !uploadedImages.isEmpty
        
        // 3. 제목이 입력되어 있는지 (1바이트 이상)
        let hasTitleInput = !title.isEmpty
        
        // 4. 내용이 입력되어 있는지 (1바이트 이상)
        let hasContentInput = !content.isEmpty
        
        // 5. 사이즈가 선택되어 있는지
        let hasSelectedSize = selectedSize != nil
        
        // 모든 필수 조건이 충족되었는지 확인
        return hasSelectedItem && hasUploadedImage && hasTitleInput && hasContentInput && hasSelectedSize
    }
    
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
                            ItemsButton(
                                title: item,
                                isSelected: selectedItem == item,
                                onTap: {
                                    selectedItem = (selectedItem == item) ? nil : item
                                }
                            )
                        }
                    } // HStack
                    
                    // 사진 업로드
                    HStack {
                        Text("최대 다섯 장까지 가능해요")
                            .font(.custom("Pretendard Variable", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(hex: 0xFFFFFF))
                        Spacer()
                        Text("*필수")
                            .foregroundStyle(Color(hex: 0x43C9B3))
                            .font(.custom("Pretendard Variable", size: 12))
                    }
                    // 사진 추가
                    PhotoUploaderView(images: $uploadedImages)

                    // 텍스트 필드
                    HStack {
                        Text("패션템 이름을 적어주세요")
                            .font(.custom("Pretendard Variable", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(hex: 0xFFFFFF))
                        Spacer()
                        Text("*필수")
                            .foregroundStyle(Color(hex: 0x43C9B3))
                            .font(.custom("Pretendard Variable", size: 12))
                    }
                    TextField("", text: $title, prompt: Text("Title Box").foregroundColor(Color(hex: 0xC7C7CC)))
                        .padding()
                        .background(Color(hex: 0x36363F))
                        .foregroundColor(Color(hex: 0xC7C7CC))
                        .cornerRadius(8)
                    
                    HStack {
                        Text("당신의 패션템을 소개해주세요")
                            .font(.custom("Pretendard Variable", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(hex: 0xFFFFFF))
                        Spacer()
                        Text("*필수")
                            .foregroundStyle(Color(hex: 0x43C9B3))
                            .font(.custom("Pretendard Variable", size: 12))
                    }
                    LimitedTextEditor(
                        text: $content,
                        placeholder: "Text contents",
                        maxCharacters: 300
                    )
                    
                    // 사이즈
                    HStack {
                        SectionTitle(title: "사이즈를 골라주세요")
                        Spacer()
                        Text("*필수")
                            .foregroundStyle(Color(hex: 0x43C9B3))
                            .font(.custom("Pretendard Variable", size: 12))
                    }
                    // 사이즈 버튼
                    HStack{
                        ForEach(0...3, id: \.self) { idx in
                            SizesButton(
                                title: sizes[idx],
                                isSelected: selectedSize == sizes[idx],
                                onTap: {
                                    selectedSize = (selectedSize == sizes[idx]) ? nil : sizes[idx]
                                }
                            )
                        }
                    } // HStack
                    HStack {
                        ForEach(4..<sizes.count, id: \.self) { idx in
                            SizesButton(
                                title: sizes[idx],
                                isSelected: selectedSize == sizes[idx],
                                onTap: {
                                    selectedSize = (selectedSize == sizes[idx]) ? nil : sizes[idx]
                                }
                            )
                        }
                    } // HStack
                    
                    // 날짜
                    SectionTitle(title: "사용한 날짜를 입력해주세요")
                    // DataPicker
                    CustomDatePicker()
                    
                    // 판매 여부
                    Toggle("판매를 희망하시나요?", isOn: $isForSale)
                        .toggleStyle(CustomToggleStyle())
                    
                    // 완료 버튼
                    CompletionButton(isFormCompleted: isFormCompleted) {
                        // 완료 버튼 클릭 시 수행할 액션
                        print("업로드 완료!")
                        // 여기에 업로드 로직 추가
                    }
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
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(title)
                .font(.custom("Pretendard Variable", size: 14))
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(isSelected ? Color(hex: 0x43C9B3) : Color(hex: 0x36363F))
                .foregroundColor(isSelected ? Color(hex: 0x2C2C36) : Color(hex: 0x8E8E93))
                .cornerRadius(6)
        }
    }
}

// 사이즈 버튼
struct SizesButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(title)
                .font(.custom("Pretendard Variable", size: 16))
                .frame(width: 60, height: 40)
                .background(isSelected ? Color(hex: 0x43C9B3) : Color(hex: 0x36363F))
                .foregroundColor(isSelected ? Color(hex: 0x2C2C36) : Color(hex: 0x8E8E93))
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

// 커스텀 텍스트 에디터
struct LimitedTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let maxCharacters: Int
    
    private var characterCount: Int {
        text.count
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // TextEditor
            TextEditor(text: Binding(
                get: { self.text },
                set: { newValue in
                    // 글자 수 제한 적용
                    if newValue.count <= maxCharacters {
                        self.text = newValue
                    } else {
                        self.text = String(newValue.prefix(maxCharacters))
                    }
                }
            ))
            .padding(5)
            .foregroundColor(.white) // 입력 텍스트는 흰색으로
            .scrollContentBackground(.hidden) // iOS 16+ 배경 숨기기
            .background(Color(hex: 0x36363F)) // TextEditor 배경색 설정
            .cornerRadius(8) // cornerRadius 유지
            
            // Placeholder (텍스트가 비어있을 때만 표시)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(hex: 0xC7C7CC))
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .allowsHitTesting(false) // 터치 이벤트가 아래 레이어로 전달되게 함
            }
            
            // 글자 수 카운터
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(characterCount)/\(maxCharacters)")
                        .foregroundColor(Color(hex: 0xC7C7CC))
                        .font(.caption)
                        .padding(6)
                }
            }
        }
        .frame(height: 120)
    }
}

// 토글 스타일
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.custom("Pretendard Variable", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(Color(hex: 0xFFFFFF))
            
            Spacer()
            
            // 커스텀 토글 배경과 써클
            ZStack {
                // 배경 캡슐
                Capsule()
                    .fill(Color(hex: 0x36363F))
                    .frame(width: 51, height: 31)
                
                // 토글 써클
                Circle()
                    .fill(configuration.isOn ? Color(hex: 0x43C9B3) : Color(hex: 0x8E8E93))
                    .frame(width: 25, height: 25)
                    .offset(x: configuration.isOn ? 10 : -10, y: 0)
                    .animation(.spring(response: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
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
