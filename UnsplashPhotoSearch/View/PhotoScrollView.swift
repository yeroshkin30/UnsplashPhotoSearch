//
//  PhotoScrollView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 09.04.2023.
//

import UIKit

class PhotoScrollView: UIScrollView, UIScrollViewDelegate {
    let imageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print(bounds)

    }
    private func setup() {
        addSubview(imageView)
        delegate = self
        updateMinZoomForScale(size: CGSize(width: 390, height: 818))

        setupConstraints()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func updateMinZoomForScale(size: CGSize) {
        print(" update \(size)")
        print(imageView.bounds)
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        minimumZoomScale = minScale
        zoomScale = minScale
    }
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
