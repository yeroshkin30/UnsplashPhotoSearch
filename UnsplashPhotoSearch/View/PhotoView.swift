//
//  PhotoView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 05.04.2023.
//

import UIKit
import Kingfisher

class PhotoView: UIView {
    private let likesView: LikesView = .init()
    private let scrollView: UIScrollView = .init()
    private let infoButton: UIButton = .init()
    private let imageView: UIImageView = .init()

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            updateMinZoomForScale(size: scrollView.bounds.size)
        }
    }

    var configuration: Configuration? {
        didSet {
            configurationDidChange(oldValue: oldValue)
        }
    }
    var infoButtonEvent: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(scrollView)
        addSubview(likesView)
        addSubview(infoButton)
        backgroundColor = .white

        imageView.kf.indicatorType = .activity
        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFit

        infoButton.configuration = likesView.likesButton.configuration
        infoButton.configuration?.image = UIImage(systemName: "info.circle.fill")
        infoButton.configuration?.baseForegroundColor = .gray
        infoButton.addAction(
            UIAction { _ in self.infoButtonEvent?() },
            for: .touchUpInside
        )
        setupScrollView()
        setupConstraints()
    }

    func setupConstraints() {
        likesView.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            likesView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            likesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            infoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            infoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])
    }
}

extension PhotoView: UIScrollViewDelegate {

    private func setupScrollView() {
        scrollView.addSubview(imageView)
        scrollView.delegate = self

    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func updateMinZoomForScale(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = 2
    }
}

extension PhotoView {

    struct Configuration {
        let numberOfLikes: Int
        let imageURL: URL
        let placeholder: UIImage?

        init(photo: Photo) {
            numberOfLikes = photo.likes ?? 0
            imageURL = photo.photoURL.full
            placeholder = UIImage.blurHash(from: photo)
        }
    }
}

private extension PhotoView {

    func configurationDidChange(oldValue: Configuration?) {
        guard let configuration else { return }

        likesView.likesLabel.text = "\(configuration.numberOfLikes)"

        image = configuration.placeholder

        KingfisherManager.shared.retrieveImage(with: configuration.imageURL, completionHandler: { result in
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
}
