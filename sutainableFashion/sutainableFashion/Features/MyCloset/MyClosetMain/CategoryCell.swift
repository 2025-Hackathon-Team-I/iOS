//
//  CategoryCell.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    // MARK: - Static Properties
    static let identifier = "CategoryCell"

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties
    private var isSelectedCategory = false

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        // 셀 배경 설정
        contentView.backgroundColor = UIColor(white: 0.2, alpha: 1.0) // 진한 회색
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true

        // 타이틀 레이블 추가
        contentView.addSubview(titleLabel)

        // 레이아웃 제약 조건
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Configuration
    func configure(with category: String, isSelected: Bool) {
        titleLabel.text = category
        self.isSelectedCategory = isSelected
        updateAppearance()
    }

    // MARK: - Helper Methods
    private func updateAppearance() {
        if isSelectedCategory {
            contentView.backgroundColor = UIColor(hex: "#43C9B3")
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
            titleLabel.textColor = .black
        } else {
            contentView.backgroundColor = UIColor(hex: "#36363F")
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = .white
        }
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        // 셀 재사용 시 초기화
        titleLabel.text = nil
        isSelectedCategory = false
        updateAppearance()
    }

    // 하이라이트 효과 커스터마이징
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.contentView.alpha = self.isHighlighted ? 0.7 : 1.0
                self.contentView.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.98, y: 0.98)
                    : .identity
            }
        }
    }
}
