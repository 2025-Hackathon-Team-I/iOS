//
//  SuggestViewController.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit

class SuggestViewController: UIViewController {

    // MARK: - Properties
    private var isDatePickerVisible = false

    // MARK: - UI Components
    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        button.setTitle(formatter.string(from: Date()), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        button.layer.cornerRadius = 8
        return button
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true // 초기에는 숨김
        picker.backgroundColor = .lightGray
        return picker
    }()

    private let placeField = UITextField()
    private let phoneCheckbox = UIButton(type: .system)
    private let phoneField = UITextField()
    private let openChatCheckbox = UIButton(type: .system)
    private let openChatField = UITextField()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 42/255, alpha: 1.0)

        setupUI()
        setupLayout()
    }

    // MARK: - Setup
    private func setupUI() {
        // 텍스트 필드 설정
        placeField.placeholder = "장소"
        phoneField.placeholder = "010-0000-0000"
        openChatField.placeholder = "카카오톡 오픈 채팅 링크를 입력하세요"

        for field in [placeField, phoneField, openChatField] {
            field.borderStyle = .roundedRect
            field.backgroundColor = .white
            field.translatesAutoresizingMaskIntoConstraints = false
        }

        // 체크박스 이미지
        [phoneCheckbox, openChatCheckbox].forEach {
            $0.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            $0.tintColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // 버튼 액션
        dateButton.addTarget(self, action: #selector(toggleDatePicker), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        placeField.addTarget(self, action: #selector(presentAddressSearch), for: .editingDidBegin)
    }

    // MARK: - Layout
    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentStack = UIStackView(arrangedSubviews: [
            makeTitleLabel("거래 날짜 설정"),
            dateButton,
            datePicker,
            placeField,
            horizontalField(checkbox: phoneCheckbox, field: phoneField),
            horizontalField(checkbox: openChatCheckbox, field: openChatField),
            confirmButton
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func makeTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }

    private func horizontalField(checkbox: UIButton, field: UITextField) -> UIStackView {
        let hStack = UIStackView(arrangedSubviews: [checkbox, field])
        hStack.axis = .horizontal
        hStack.spacing = 8
        checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return hStack
    }

    // MARK: - Actions
    @objc private func toggleDatePicker() {
        isDatePickerVisible.toggle()
        datePicker.isHidden = !isDatePickerVisible
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateButton.setTitle(formatter.string(from: sender.date), for: .normal)
    }

    // SuggestViewController.swift 내부
    @objc private func presentAddressSearch() {
        let vc = AddressSearchViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

}

extension SuggestViewController: AddressSearchDelegate {
    func didSelectAddress(_ address: String) {
        placeField.text = address
    }
}
