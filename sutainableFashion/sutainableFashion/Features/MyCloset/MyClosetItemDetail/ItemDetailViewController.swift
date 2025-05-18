//
//  ItemDetailViewController.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/17/25.
//


import UIKit

class ItemDetailViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let imageSlider = ImageSliderView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#E5E5EA")
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#C7C7CC")
        return label
    }()

    private let chipButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(hex: "#34AD99")
        button.setTitleColor(UIColor(hex: "#36363F"), for: .normal)
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 19, bottom: 2, right: 19)
        button.isUserInteractionEnabled = false
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#34AD99")
        label.numberOfLines = 0
        return label
    }()

    private let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "paperplane.fill") // 또는 원하는 이미지
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(hex: "#43C9B3")
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()


    private let item: ClothingItem

    init(item: ClothingItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
        configure(with: item)
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(floatingButton)


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

            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                floatingButton.widthAnchor.constraint(equalToConstant: 56),
                floatingButton.heightAnchor.constraint(equalToConstant: 56)
        ])

        imageSlider.translatesAutoresizingMaskIntoConstraints = false
        imageSlider.heightAnchor.constraint(equalToConstant: 260).isActive = true

        let titleRow = UIStackView(arrangedSubviews: [titleLabel, chipButton])
        titleRow.axis = .horizontal
        titleRow.distribution = .equalSpacing

        [imageSlider, titleRow, dateLabel, descriptionLabel, tagsLabel].forEach {
            contentStack.addArrangedSubview($0)
        }
    }

    private func configure(with item: ClothingItem) {
        titleLabel.text = item.name
        chipButton.setTitle(item.size, for: .normal)
        dateLabel.text = "등록일자: \(item.startDate)"
        descriptionLabel.text = item.description
        tagsLabel.text = item.tags.map { "#\($0)" }.joined(separator: " ")

        imageSlider.configure(with: item.imageURL.isEmpty ? ["https://via.placeholder.com/300"] : [item.imageURL])
    }

    @objc private func floatingButtonTapped() {
        print("플로팅 버튼 탭됨")
        let chipVC = SuggestViewController()
        navigationController?.pushViewController(chipVC, animated: true)
        // 공유하기, 트레이 담기 등 원하는 동작 구현
    }
}

class ImageSliderView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var imageURLs: [String] = []
    private var collectionView: UICollectionView!
    private let pageControl = UIPageControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupPageControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        setupPageControl()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageSliderCell.self, forCellWithReuseIdentifier: ImageSliderCell.identifier)

        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func configure(with urls: [String]) {
        self.imageURLs = urls
        pageControl.numberOfPages = urls.count
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSliderCell.identifier, for: indexPath) as? ImageSliderCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLs[indexPath.item])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = page
    }
}
