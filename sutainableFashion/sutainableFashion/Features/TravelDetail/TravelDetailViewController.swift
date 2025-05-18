//
//  TravelDetailViewController.swift
//  sutainableFashion
//
//  Created by 김사랑 on 5/18/25.
//

import UIKit
import MapKit
import Combine

class TravelDetailViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: TravelDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "승환킴 의 여정"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
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

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let purchaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sellDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let locationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.circle.fill")
        imageView.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.7, alpha: 1.0) // 민트색
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tripSectionTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tripIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "suitcase.fill")
        imageView.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.7, alpha: 1.0) // 민트색
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let tripTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행 기록"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tripCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 3명"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false // 스크롤뷰 내부에 있으므로 비활성화
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let totalCostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let travelLocationSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let travelLocationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "map.fill")
        imageView.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.7, alpha: 1.0) // 민트색
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let travelLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "여정 기록"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mapContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 12
        mapView.clipsToBounds = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private let noTravelLabel: UILabel = {
        let label = UILabel()
        label.text = "이 패션템의 여정이 지도에 표시됩니다!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization
    init(viewModel: TravelDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupMapView()
        setupBindings()
        viewModel.loadData()

        self.hidesBottomBarWhenPushed = false
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black

        // 스크롤뷰 설정
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // 헤더 뷰 추가
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(searchButton)

        // 콘텐츠 뷰에 요소 추가
        contentView.addSubview(imageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(purchaseDateLabel)
        contentView.addSubview(sellDateLabel)

        // 현재 위치 컨테이너
        contentView.addSubview(locationContainerView)
        locationContainerView.addSubview(locationIconView)
        locationContainerView.addSubview(currentLocationLabel)

        // 여행 기록 섹션
        contentView.addSubview(tripSectionTitleView)
        tripSectionTitleView.addSubview(tripIconView)
        tripSectionTitleView.addSubview(tripTitleLabel)
        tripSectionTitleView.addSubview(tripCountLabel)

        // 여행 히스토리 테이블뷰
        contentView.addSubview(historyTableView)
        contentView.addSubview(totalCostLabel)

        // 여행 위치 섹션
        contentView.addSubview(travelLocationSectionView)
        travelLocationSectionView.addSubview(travelLocationIconView)
        travelLocationSectionView.addSubview(travelLocationTitleLabel)

        // 지도 컨테이너
        contentView.addSubview(mapContainerView)
        mapContainerView.addSubview(mapView)
        mapContainerView.addSubview(noTravelLabel)

        setupConstraints()
        setupActions()
    }

    private func setupConstraints() {
        // 제약조건 설정
        NSLayoutConstraint.activate([
            // 헤더 제약조건
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            searchButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),

            // 스크롤뷰 제약조건
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // 이미지 제약조건
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6),

            // 아이템 정보 제약조건
            itemNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            purchaseDateLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 8),
            purchaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            sellDateLabel.topAnchor.constraint(equalTo: purchaseDateLabel.bottomAnchor, constant: 4),
            sellDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // 현재 위치 컨테이너 제약조건
            locationContainerView.topAnchor.constraint(equalTo: sellDateLabel.bottomAnchor, constant: 16),
            locationContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationContainerView.heightAnchor.constraint(equalToConstant: 44),

            locationIconView.leadingAnchor.constraint(equalTo: locationContainerView.leadingAnchor, constant: 12),
            locationIconView.centerYAnchor.constraint(equalTo: locationContainerView.centerYAnchor),
            locationIconView.widthAnchor.constraint(equalToConstant: 24),
            locationIconView.heightAnchor.constraint(equalToConstant: 24),

            currentLocationLabel.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 12),
            currentLocationLabel.centerYAnchor.constraint(equalTo: locationContainerView.centerYAnchor),
            currentLocationLabel.trailingAnchor.constraint(equalTo: locationContainerView.trailingAnchor, constant: -12),

            // 여행 기록 섹션 제약조건
            tripSectionTitleView.topAnchor.constraint(equalTo: locationContainerView.bottomAnchor, constant: 24),
            tripSectionTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tripSectionTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tripSectionTitleView.heightAnchor.constraint(equalToConstant: 30),

            tripIconView.leadingAnchor.constraint(equalTo: tripSectionTitleView.leadingAnchor),
            tripIconView.centerYAnchor.constraint(equalTo: tripSectionTitleView.centerYAnchor),
            tripIconView.widthAnchor.constraint(equalToConstant: 24),
            tripIconView.heightAnchor.constraint(equalToConstant: 24),

            tripTitleLabel.leadingAnchor.constraint(equalTo: tripIconView.trailingAnchor, constant: 8),
            tripTitleLabel.centerYAnchor.constraint(equalTo: tripSectionTitleView.centerYAnchor),

            tripCountLabel.trailingAnchor.constraint(equalTo: tripSectionTitleView.trailingAnchor),
            tripCountLabel.centerYAnchor.constraint(equalTo: tripSectionTitleView.centerYAnchor),

            // 히스토리 테이블뷰 제약조건
            historyTableView.topAnchor.constraint(equalTo: tripSectionTitleView.bottomAnchor, constant: 8),
            historyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            historyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            historyTableView.heightAnchor.constraint(equalToConstant: 180), // 3개 셀 표시 (각 60 높이)

            totalCostLabel.topAnchor.constraint(equalTo: historyTableView.bottomAnchor, constant: 8),
            totalCostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // 여행 위치 섹션 제약조건
            travelLocationSectionView.topAnchor.constraint(equalTo: totalCostLabel.bottomAnchor, constant: 24),
            travelLocationSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            travelLocationSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            travelLocationSectionView.heightAnchor.constraint(equalToConstant: 30),

            travelLocationIconView.leadingAnchor.constraint(equalTo: travelLocationSectionView.leadingAnchor),
            travelLocationIconView.centerYAnchor.constraint(equalTo: travelLocationSectionView.centerYAnchor),
            travelLocationIconView.widthAnchor.constraint(equalToConstant: 24),
            travelLocationIconView.heightAnchor.constraint(equalToConstant: 24),

            travelLocationTitleLabel.leadingAnchor.constraint(equalTo: travelLocationIconView.trailingAnchor, constant: 8),
            travelLocationTitleLabel.centerYAnchor.constraint(equalTo: travelLocationSectionView.centerYAnchor),

            // 지도 컨테이너 제약조건
            mapContainerView.topAnchor.constraint(equalTo: travelLocationSectionView.bottomAnchor, constant: 8),
            mapContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapContainerView.heightAnchor.constraint(equalToConstant: 200),
            mapContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // 스크롤뷰 끝

            mapView.topAnchor.constraint(equalTo: mapContainerView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor),

            noTravelLabel.centerXAnchor.constraint(equalTo: mapContainerView.centerXAnchor),
            noTravelLabel.centerYAnchor.constraint(equalTo: mapContainerView.centerYAnchor)
        ])
    }

    private func setupTableView() {
        historyTableView.register(TravelHistoryCell.self, forCellReuseIdentifier: TravelHistoryCell.identifier)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.rowHeight = 60
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = false

        // 초기 지도 설정 (서울 중심)
        let initialLocation = CLLocation(latitude: 37.5665, longitude: 126.9780)
        let regionRadius: CLLocationDistance = 50000
        let coordinateRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(coordinateRegion, animated: false)
    }

    private func setupBindings() {
        viewModel.$item
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self, let item = item else { return }
                self.updateUI(with: item)
            }
            .store(in: &cancellables)

        viewModel.$travelHistories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.historyTableView.reloadData()
                self?.updateTripCountLabel()
            }
            .store(in: &cancellables)

        viewModel.$travelLocations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locations in
                self?.updateMapView(with: locations)
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    // MARK: - UI Update
    private func updateUI(with item: DetailedClothingItem) {
            itemNameLabel.text = item.name
            purchaseDateLabel.text = "최초 일자: \(item.startDate)"
            sellDateLabel.text = "판매 일자: \(item.endDate)"
            currentLocationLabel.text = item.currentLocation

            // 이미지 설정
            if !item.imageURL.isEmpty, let url = URL(string: item.imageURL) {
                URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(systemName: "tshirt.fill")
                        }
                    }
                }.resume()
            } else {
                imageView.image = UIImage(systemName: "tshirt.fill")
            }

            // 총 비용 업데이트
            totalCostLabel.text = "전체 사용 기간: \(item.usedDays)일"
        }

    private func updateTripCountLabel() {
        let count = viewModel.travelHistories.count
        tripCountLabel.text = "총 \(count)명"
    }

    private func updateMapView(with locations: [TravelLocation]) {
        // 기존 핀 제거
        mapView.removeAnnotations(mapView.annotations)

        if locations.isEmpty {
            // 위치 정보가 없는 경우
            noTravelLabel.isHidden = false
            return
        }

        noTravelLabel.isHidden = true

        // 핀 추가
        var annotations: [MKPointAnnotation] = []

        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.name
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)

        // 모든 핀이 보이도록 지도 범위 조정
        if !locations.isEmpty {
            mapView.showAnnotations(annotations, animated: true)
        }
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func searchButtonTapped() {
        // 검색 기능 구현
        print("Search button tapped")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TravelDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.travelHistories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravelHistoryCell.identifier, for: indexPath) as? TravelHistoryCell else {
            return UITableViewCell()
        }

        let history = viewModel.travelHistories[indexPath.row]
        cell.configure(with: history, index: indexPath.row + 1)

        return cell
    }
}

// MARK: - MKMapViewDelegate
extension TravelDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "TravelPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }

        if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
            markerAnnotationView.markerTintColor = UIColor(red: 0.3, green: 0.8, blue: 0.7, alpha: 1.0) // 민트색
        }

        return annotationView
    }
}


//import UIKit

class TravelHistoryCell: UITableViewCell {
    static let identifier = "TravelHistoryCell"

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(indexLabel)
        containerView.addSubview(ownerNameLabel)
        containerView.addSubview(dateRangeLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            indexLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 20),

            ownerNameLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 16),
            ownerNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            dateRangeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dateRangeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dateRangeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: ownerNameLabel.trailingAnchor, constant: 12)
        ])
    }
    // TravelHistoryCell.swift에 추가할 메서드
    // MARK: - Configuration
    func configure(with history: TravelHistory, index: Int) {
        indexLabel.text = "\(index)"
        ownerNameLabel.text = history.ownerName
        dateRangeLabel.text = "\(history.startDate) ~ \(history.endDate)"
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        indexLabel.text = nil
        ownerNameLabel.text = nil
        dateRangeLabel.text = nil
    }
}
