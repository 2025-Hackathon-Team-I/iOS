//
//  MyClosetViewController.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit
import Combine

class MyClosetViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = MyClosetViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "승환킴의 옷장"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 70, height: 30)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableViewAndCollectionView()
        setupBindings()
        viewModel.loadClosetItems()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        // 배경색 설정
        view.backgroundColor = UIColor(hex: "#202020")

        // 내비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: false)

        // 상단 헤더 UI 추가
        view.addSubview(titleLabel)
        view.addSubview(searchButton)

        // 카테고리 컬렉션뷰 추가
        view.addSubview(categoryCollectionView)

        // 테이블뷰 추가
        view.addSubview(tableView)

        // 로딩 인디케이터
        view.addSubview(loadingIndicator)

        view.addSubview(topBorder)
        view.addSubview(bottomBorder)


        NSLayoutConstraint.activate([
            // 타이틀 레이블 제약 조건
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // 검색 버튼 제약 조건
            searchButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),

            topBorder.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            topBorder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            topBorder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            topBorder.heightAnchor.constraint(equalToConstant: 1),

            // 카테고리 컬렉션뷰 제약 조건
            categoryCollectionView.topAnchor.constraint(equalTo: topBorder.bottomAnchor, constant: 7),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),

            bottomBorder.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 7),
            bottomBorder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bottomBorder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),

            // 테이블뷰 제약 조건
            tableView.topAnchor.constraint(equalTo: bottomBorder.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // 로딩 인디케이터
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        // 버튼 액션 설정
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    private func setupTableViewAndCollectionView() {
        // 테이블뷰 설정
        tableView.register(ClothingItemTableViewCell.self, forCellReuseIdentifier: ClothingItemTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableView.automaticDimension

        // 카테고리 컬렉션뷰 설정
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }

    // Combine 바인딩 설정
    private func setupBindings() {
        // 로딩 상태 바인딩
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)

        // 에러 메시지 바인딩
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }
            .store(in: &cancellables)

        // 카테고리 바인딩
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.categoryCollectionView.reloadData()
            }
            .store(in: &cancellables)

        // 선택된 카테고리 인덱스 바인딩
        viewModel.$selectedCategoryIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.categoryCollectionView.reloadData()
            }
            .store(in: &cancellables)

        // 아이템 목록 바인딩
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$userNickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                self?.titleLabel.text = "\(nickname)의 옷장"
            }
            .store(in: &cancellables)

    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    @objc private func searchButtonTapped() {
        // 검색 화면으로 이동
        print("검색 버튼 탭")
    }

    @objc private func notificationButtonTapped() {
        // 알림 화면으로 이동
        print("알림 버튼 탭")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyClosetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClothingItemTableViewCell.identifier, for: indexPath) as? ClothingItemTableViewCell else {
            return UITableViewCell()
        }

        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self
        print("Cell configured with delegate")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // 아이템 선택 시 상세 화면으로 이동
        let item = viewModel.items[indexPath.row]
        let detailVC = ItemDetailViewController(item: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // 스와이프 액션 추가 (삭제, 편집 등)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return viewModel.getSwipeActions(for: indexPath)
    }
}

// MARK: - ClothingItemTableViewCellDelegate
extension MyClosetViewController: ClothingItemTableViewCellDelegate {
    func didTapChip(for item: ClothingItem) {
        print("불러온 아이템: \(item.name)")
        let chipVC = SuggestViewController()
        navigationController?.pushViewController(chipVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MyClosetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        let category = viewModel.categories[indexPath.item]
        cell.configure(with: category, isSelected: viewModel.selectedCategoryIndex == indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedCategoryIndex = indexPath.item
    }
}
