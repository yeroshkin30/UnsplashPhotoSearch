//
//  PhotoScrollView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 09.04.2023.
//

import UIKit

class PhotoScrollView: UIScrollView {
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

    private func setup() {
        addSubview(imageView)
        delegate = self
        contentInsetAdjustmentBehavior = .never
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
        setupContentInset()
    }

    private func updateMinZoomForScale(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        minimumZoomScale = minScale
        zoomScale = minScale
    }

    private func setupContentInset() {
        var hInset = (bounds.width - contentSize.width) / 2
        var vInset = (bounds.height - contentSize.height) / 2

        hInset = hInset > 0 ? hInset : 0
        vInset = vInset > 0 ? vInset : 0

        contentInset = UIEdgeInsets(top: vInset, left: hInset, bottom: vInset, right: hInset)
    }
}

extension PhotoScrollView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setupContentInset()
    }
}
