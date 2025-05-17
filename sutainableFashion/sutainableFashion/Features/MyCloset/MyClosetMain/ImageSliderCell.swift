//
//  ImageSliderCell.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/18/25.
//

import UIKit
import Combine

class ImageSliderCell: UICollectionViewCell {
    // MARK: - Static Properties
    static let identifier = "ImageSliderCell"

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with imageURL: String) {
        loadingIndicator.startAnimating()

        // 임시
        let dummyImages: [String: UIImage?] = [
            "dummy1": UIImage(systemName: "tshirt.fill"),
            "dummy2": UIImage(systemName: "bag.fill"),
            "dummy3": UIImage(systemName: "eyeglasses")
        ]

        if let image = dummyImages[imageURL] {
            imageView.image = image
            loadingIndicator.stopAnimating()
            return
        }

        // 실 이미지 로드용
        if let url = URL(string: imageURL) {
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: UIImage(systemName: "tshirt.fill"))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.imageView.image = image
                    self?.loadingIndicator.stopAnimating()
                }
                .store(in: &cancellables)
        } else {
            imageView.image = UIImage(systemName: "tshirt.fill")
            loadingIndicator.stopAnimating()
        }
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        cancellables.removeAll()
    }
}
