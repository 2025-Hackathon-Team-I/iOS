//
//  CommentCell.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

struct Comment {
    let nickname: String
    let content: String
}


import UIKit

class CommentCell: UITableViewCell {
    static let identifier = "CommentCell"

    private let nicknameLabel = UILabel()
    private let contentLabel = UILabel()
    private let checkbox = UIView() // 이미지로 바꿔도 OK

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        backgroundColor = .black
        nicknameLabel.font = .boldSystemFont(ofSize: 14)
        nicknameLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.textColor = .lightGray
        contentLabel.numberOfLines = 3
        checkbox.backgroundColor = .white
        checkbox.layer.cornerRadius = 4

        for v in [nicknameLabel, contentLabel, checkbox] { v.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(v) }

        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkbox.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            checkbox.widthAnchor.constraint(equalToConstant: 14),
            checkbox.heightAnchor.constraint(equalToConstant: 14),

            contentLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 6),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with comment: Comment) {
        nicknameLabel.text = comment.nickname
        contentLabel.text = comment.content
    }
}
