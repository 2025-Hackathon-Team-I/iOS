//
//  ItemDetailViewController.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit

class ItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    private let item: ClothingItem
//    private let comments: [Comment] = [] // 나중에 백엔드 연동

    // MARK: - UI
    private let tableView = UITableView()
    private let headerView = ItemHeaderView()

    // MARK: - Init
    init(item: ClothingItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private let comments: [Comment] = [
        Comment(nickname: "수진", content: "이 옷 너무 예뻐요!"),
        Comment(nickname: "사랑", content: "판매하시나요? 관심 있어요~")
    ]


    private func setupUI() {
        view.backgroundColor = .black

        // 테이블뷰 설정
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)

        view.addSubview(tableView)

        // 레이아웃
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // 헤더 설정
        headerView.configure(with: item)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
//        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
        tableView.tableHeaderView = headerView

    }

    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.configure(with: comments[indexPath.row])
        return cell
    }

}

