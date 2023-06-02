//
//  PhotoDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

class PhotoDetailView: UIView {
    private let countryNameLabel: UILabel = .init()
    private let cityNameLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private let mapView: MKMapView = .init()

    init() {
        super.init(frame: CGRect())
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


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

    private func setupView() {
        backgroundColor = .gray
        addSubview(stackView)
        mapView.isHidden = true

        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(countryNameLabel)
        stackView.addArrangedSubview(cityNameLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution  = .fill
        stackView.spacing = 8

        cityNameLabel.font = UIFont.systemFont(ofSize: 20)
        countryNameLabel.font = UIFont.systemFont(ofSize: 20)
        countryNameLabel.text = "Country:"
        cityNameLabel.text = "City:"

        setupConstraints()
    }



    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        }

        mapView.snp.makeConstraints { make in
            make.height.equalTo(snp.height).multipliedBy(0.3)
            make.width.equalTo(stackView.snp.width)
        }
    }
}
