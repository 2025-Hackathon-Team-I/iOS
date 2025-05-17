//
//  MyClosetViewModel.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//


import Foundation
import Combine
import UIKit

class MyClosetViewModel {
    // MARK: - Published 프로퍼티 (반응형 데이터)
    @Published var userNickname: String = "."
    @Published var categories = ClothingItem.Category.all
    @Published var selectedCategoryIndex = 0
    @Published var allItems: [ClothingItem] = []
    @Published var items: [ClothingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // MARK: - Private 프로퍼티
    private var cancellables = Set<AnyCancellable>()

    // MARK: - 초기화
    init() {
        setupBindings()
    }

    // MARK: - Private 메서드
    private func setupBindings() {
        // 카테고리 선택 변경 시 자동 필터링
        $selectedCategoryIndex
            .dropFirst() // 초기값은 무시
            .sink { [weak self] _ in
                self?.filterItems()
            }
            .store(in: &cancellables)
    }


    private func filterItems() {
            let selectedCategory = selectedCategoryIndex == 0 ? nil : categories[selectedCategoryIndex]

            if let category = selectedCategory {
                items = allItems.filter { $0.category == category }
            } else {
                items = allItems
            }
        }

        // MARK: - Public 메서드
        func loadClosetItems() {
            isLoading = true
            errorMessage = nil

            // 백엔드 API 호출 시뮬레이션
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    // 더미 데이터 사용
                    self.allItems = self.createDummyItems()
                    self.items = self.allItems
                    self.isLoading = false

                    // 현재 필터 적용
                    if self.selectedCategoryIndex > 0 {
                        self.filterItems()
                    }
                }
            }
        }

        func loadUserInfo() {
            // 나중에 서버에서 닉네임을 불러오는 코드로 대체
            self.userNickname = ""
        }


        // 아이템 삭제
        func deleteItem(at indexPath: IndexPath) {
            guard indexPath.row < items.count else { return }

            let itemToDelete = items[indexPath.row]

            // 실제로는 네트워크 요청 후 성공 시 삭제
            if let index = allItems.firstIndex(where: { $0.id == itemToDelete.id }) {
                allItems.remove(at: index)
                filterItems() // 현재 필터 적용하여 items 업데이트
            }
        }

        // 스와이프 액션 설정 (삭제, 편집 등)
        func getSwipeActions(for indexPath: IndexPath) -> UISwipeActionsConfiguration {
            // 삭제 액션
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completion) in
                self?.deleteItem(at: indexPath)
                completion(true)
            }
            deleteAction.backgroundColor = .systemRed

            // 판매하기 액션
            let sellAction = UIContextualAction(style: .normal, title: "판매") { [weak self] (_, _, completion) in
                guard let self = self, indexPath.row < self.items.count else {
                    completion(false)
                    return
                }

                // 판매 로직 구현 (판매 화면으로 이동 등)
                print("아이템 판매하기: \(self.items[indexPath.row].name)")
                completion(true)
            }
            sellAction.backgroundColor = .systemBlue

            // 액션 설정
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, sellAction])
            return configuration
        }

        // MARK: - Helper Methods
        private func createDummyItems() -> [ClothingItem] {
            let descriptionText = "임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트 임텍스트"

            return [
                ClothingItem(
                    id: "1",
                    name: "블랙 티셔츠",
                    imageURL: "",
                    category: "상의",
                    description: descriptionText,
                    startDate: "2025. 01. 01",
                    endDate: "2025. 05. 01",
                    size: "L",
                    tags: ["기본", "블랙", "티셔츠", "데일리"],
                    isForSale: false
                ),
                ClothingItem(
                    id: "2",
                    name: "청바지",
                    imageURL: "",
                    category: "하의",
                    description: descriptionText,
                    startDate: "2025. 02. 01",
                    endDate: "2025. 06. 01",
                    size: "32",
                    tags: ["데님", "청바지", "캐주얼", "슬림핏", "코디", "데일리", "데님", "청바지", "캐주얼", "슬림핏", "코디", "데일리"],
                    isForSale: false
                ),
                ClothingItem(
                    id: "3",
                    name: "흰색 스니커즈",
                    imageURL: "",
                    category: "신발",
                    description: descriptionText,
                    startDate: "2025. 03. 01",
                    endDate: "2025. 07. 01",
                    size: "265",
                    tags: ["스니커즈", "화이트", "캔버스", "데일리", "캐주얼"],
                    isForSale: false
                ),
                ClothingItem(
                    id: "4",
                    name: "블랙 맨투맨",
                    imageURL: "",
                    category: "상의",
                    description: descriptionText,
                    startDate: "2025. 01. 15",
                    endDate: "2025. 05. 15",
                    size: "XL",
                    tags: ["맨투맨", "블랙", "캐주얼", "데일리"],
                    isForSale: true
                ),
                ClothingItem(
                    id: "5",
                    name: "카고 팬츠",
                    imageURL: "",
                    category: "하의",
                    description: descriptionText,
                    startDate: "2025. 02. 15",
                    endDate: "2025. 06. 15",
                    size: "30",
                    tags: ["카고", "팬츠", "카키", "스트릿", "빈티지"],
                    isForSale: false
                ),
                ClothingItem(
                    id: "6",
                    name: "검정 모자",
                    imageURL: "",
                    category: "기타",
                    description: descriptionText,
                    startDate: "2025. 03. 15",
                    endDate: "2025. 07. 15",
                    size: "FREE",
                    tags: ["모자", "블랙", "캡", "스냅백", "데일리", "캐주얼"],
                    isForSale: false
                )
            ]
        }
    }
