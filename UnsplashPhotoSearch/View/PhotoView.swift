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
    private let imageView: UIImageView = .init()
    private let infoButton: UIButton = .init()

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
        addSubview(imageView)
        addSubview(likesView)
        addSubview(infoButton)
        backgroundColor = .black

        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity

        infoButton.configuration = likesView.likesButton.configuration
        infoButton.configuration?.image = UIImage(systemName: "info.circle.fill")
        infoButton.configuration?.baseForegroundColor = .gray
        infoButton.addAction(
            UIAction { _ in self.infoButtonEvent?() },
            for: .touchUpInside
        )
        setupConstraints()
    }

    func setupConstraints() {
        likesView.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            likesView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            likesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            infoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            infoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])

    }

}

extension PhotoView {

    struct Configuration {
        let numberOfLikes: Int
        let imageURL: URL
        let placeholder: UIImage?

        init(photo: Photo) {
            numberOfLikes = photo.likes ?? 0
            imageURL = photo.photoURL.regular
            placeholder = UIImage.blurHash(from: photo)
        }
    }
}

private extension PhotoView {

    func configurationDidChange(oldValue: Configuration?) {
        guard let configuration else { return }

        likesView.likesLabel.text = "\(configuration.numberOfLikes)"

        guard oldValue?.imageURL != configuration.imageURL else { return }

        imageView.kf.setImage(
            with: configuration.imageURL,
            placeholder: imageView.image ?? configuration.placeholder,
            options: [.transition(.fade(0.2)),]
        )
    }
}
