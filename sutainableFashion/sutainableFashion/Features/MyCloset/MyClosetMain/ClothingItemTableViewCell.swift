//
//  ClothingItemTableViewCell.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//

import UIKit
import Combine

protocol ClothingItemTableViewCellDelegate: AnyObject {
    func didTapChip(for item: ClothingItem)
}

class ClothingItemTableViewCell: UITableViewCell {
    // MARK: - Static Properties
    static let identifier = "ClothingItemTableViewCell"

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var imageURLs: [String] = []
    private var item: ClothingItem?
    weak var delegate: ClothingItemTableViewCellDelegate?

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageSliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.2, green: 0.8, blue: 0.8, alpha: 1.0) // 민트색
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#E5E5EA")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#C7C7CC")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chip", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(hex: "#34AD99")
        button.setTitleColor(UIColor(hex: "#36363F"), for: .normal)
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 19, bottom: 2, right: 19)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#34AD99")
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let moreLabel: UILabel = {
        let label = UILabel()
        label.text = "...더보기"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#676771")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCollectionView()
        setupActions()

        // 버튼이 콘텐츠 뷰 위에 명확하게 보이도록 zPosition 설정
        chipButton.layer.zPosition = 1

        // 사용자 상호작용 명시적으로 활성화
        contentView.isUserInteractionEnabled = true
        chipButton.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        // 컨테이너 뷰 추가
        contentView.addSubview(containerView)

        // 컨테이너 내부 요소 추가
        containerView.addSubview(imageSliderCollectionView)
        containerView.addSubview(pageControl)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(chipButton)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(tagsLabel)
        containerView.addSubview(moreLabel)

        NSLayoutConstraint.activate([
            // 컨테이너 뷰
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // 이미지 슬라이더
            imageSliderCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageSliderCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageSliderCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageSliderCollectionView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8), // 가로 세로 비율 설정

            // 페이지 컨트롤
            pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: imageSliderCollectionView.bottomAnchor, constant: -8),

            // 타이틀 레이블
            titleLabel.topAnchor.constraint(equalTo: imageSliderCollectionView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

            // 칩 버튼
            chipButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            chipButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            // 날짜 레이블
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            // 설명 레이블
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            // 태그 레이블
            tagsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            tagsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            moreLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 8),
            moreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            moreLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    private func setupCollectionView() {
        imageSliderCollectionView.register(ImageSliderCell.self, forCellWithReuseIdentifier: ImageSliderCell.identifier)
        imageSliderCollectionView.delegate = self
        imageSliderCollectionView.dataSource = self

        // 페이지 변경 감지
        imageSliderCollectionView.isPagingEnabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 셀의 선택 영역이 칩 버튼을 가리지 않도록 조정
        // 콘텐츠 뷰의 영역을 조정해 버튼 이벤트가 잘 전달되도록 함
        let buttonFrame = chipButton.convert(chipButton.bounds, to: contentView)
        contentView.largeContentImageInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: min(buttonFrame.width + 20, contentView.bounds.width / 2)
        )
    }

    private func setupActions() {
        chipButton.addTarget(self, action: #selector(chipButtonTapped), for: .touchUpInside)
    }

    @objc private func chipButtonTapped() {
        guard let item = item else { return }
        delegate?.didTapChip(for: item)
    }

    // MARK: - Configuration
    func configure(with item: ClothingItem) {
        self.item = item
        titleLabel.text = item.name
        chipButton.setTitle(item.size, for: .normal) // 또는 item.name 등 원하는 값
        dateLabel.text = "등록일자: \(item.startDate)"
        descriptionLabel.text = item.description

        // 태그 표시
        let tagsText = item.tags.map { "#\($0)" }.joined(separator: " ")
        tagsLabel.text = tagsText

        // 이미지 슬라이더 설정
        setupImageSlider(with: item)
    }

    private func setupImageSlider(with item: ClothingItem) {
        if item.imageURL.isEmpty {
            // 임시
            imageURLs = ["dummy1", "dummy2", "dummy3"]
        } else {
            imageURLs = [item.imageURL]
        }

        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = 0
        pageControl.isHidden = imageURLs.count <= 1

        imageSliderCollectionView.reloadData()
    }


    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        dateLabel.text = nil
        chipButton.setTitle(nil, for: .normal)
        descriptionLabel.text = nil
        tagsLabel.text = nil

        imageURLs = []
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0

        cancellables.removeAll()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ClothingItemTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCell.identifier, for: indexPath) as! ImageSliderCell

        let imageURL = imageURLs[indexPath.item]
        cell.configure(with: imageURL)

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageSliderCollectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = currentPage
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ClothingItemTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
