//
//  PhotoDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit
import MapKit
import CoreLocation


class PhotoDetailView: UIView {
    
    private let countryNameLabel: UILabel = .init()
    private let cityNameLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let mapView: MKMapView = .init()
    
    // MARK: - Inits
    
    init() {
        super.init(frame: CGRect())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    
    func locationSetup(location: Location) {
        countryNameLabel.text = "Country: \(location.country ?? "")"
        cityNameLabel.text = "City: \(location.city ?? "")"

        guard let latitude = location.position.latitude,
              let longitude = location.position.longitude else {
            return
        }
        mapView.isHidden = false
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
            animated: true
        )

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.layer.cornerRadius = 10
    }
}

// MARK: - Private methods

private extension PhotoDetailView {

    func setupView() {
        backgroundColor = .gray
        addSubview(stackView)
        mapView.isHidden = true

        setupLabels()
        setupStackView()
        setupConstraints()
    }

    func setupLabels() {
        cityNameLabel.font = UIFont.systemFont(ofSize: 20)
        countryNameLabel.font = UIFont.systemFont(ofSize: 20)
        countryNameLabel.text = "Country:"
        cityNameLabel.text = "City:"
    }

    func setupStackView() {
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(countryNameLabel)
        stackView.addArrangedSubview(cityNameLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution  = .fill
        stackView.spacing = 8
    }

    func setupConstraints() {
        stackView.layout(in: self) {
            $0.top == safeAreaLayoutGuide.topAnchor + Margins.standard2x
            $0.leading == leadingAnchor + Margins.standard2x
            $0.trailing == trailingAnchor - Margins.standard2x
            $0.bottom == safeAreaLayoutGuide.bottomAnchor
        }

        mapView.layout(in: self) {
            $0.height *= heightAnchor + 0.3
            $0.width == stackView.widthAnchor
        }
    }
}
