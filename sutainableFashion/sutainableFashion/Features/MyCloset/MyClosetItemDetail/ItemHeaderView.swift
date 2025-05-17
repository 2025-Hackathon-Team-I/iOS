//
//  ItemHeaderView.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit

class ItemHeaderView: UIView {
    private let cellView = ClothingItemTableViewCell(style: .default, reuseIdentifier: nil)

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with item: ClothingItem) {
        cellView.configure(with: item)
    }
}

