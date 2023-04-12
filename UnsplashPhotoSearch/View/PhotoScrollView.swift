//
//  PhotoScrollView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 09.04.2023.
//

import UIKit

class PhotoScrollView: UIScrollView, UIScrollViewDelegate {
    private let imageView: UIImageView = .init()
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            updateMinZoomForScale(size: self.bounds.size)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("content size: \(contentSize)")

    }
    private func setup() {
        addSubview(imageView)
        delegate = self
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func updateMinZoomForScale(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        print(imageView.frame)
        print("min zoom: \(minScale)")
        minimumZoomScale = minScale
        zoomScale = minScale
        print("content size: \(contentSize)")
    }
}
