//
//  PhotoScrollView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 09.04.2023.
//

import UIKit

class PhotoScrollView: UIScrollView, UIScrollViewDelegate {
    let imageView: UIImageView = .init()



    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func updateMinZoomForScale(size: CGSize) {
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
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
