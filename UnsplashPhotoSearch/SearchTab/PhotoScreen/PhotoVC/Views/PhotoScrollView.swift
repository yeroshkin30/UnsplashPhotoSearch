//
//  PhotoScrollView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 09.04.2023.
//

import UIKit

final class PhotoScrollView: UIScrollView {
    private let imageView: UIImageView = .init()
    private let tapGesture: UITapGestureRecognizer = .init()
    private var viewIsSet = false
    var image: UIImage? {
        didSet {
            imageView.image = image
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
        if image != nil, viewIsSet == false {
            updateMinZoomForScale(size: self.bounds.size)
            viewIsSet = true
        }
    }

    private func setup() {
        addSubview(imageView)
        delegate = self
        contentInsetAdjustmentBehavior = .never
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = bounds
        setupContentInset()
        setupGesture()
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

extension PhotoScrollView {
    func setupGesture() {
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        tapGesture.numberOfTapsRequired = 2
        tapGesture.addTarget(self, action: #selector(doubleTap))
    }

    @objc func  doubleTap(_ sender: UIGestureRecognizer) {
        if zoomScale != minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            zoomToRect(at: sender.location(in: imageView))
        }

    }

    func zoomToRect(at location: CGPoint) {
        let xOrigin = location.x - (bounds.width / 2)
        let yOrigin = location.y - (bounds.height / 2)

        let zoomRect = CGRect(x: xOrigin, y: yOrigin, width: bounds.width, height: bounds.height)

        zoom(to: zoomRect, animated: true)
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
