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
    private let scrollView: PhotoScrollView = .init()
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
        addSubview(scrollView)
        addSubview(likesView)
        addSubview(infoButton)
        backgroundColor = .white

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

        scrollView.image = configuration.placeholder

        KingfisherManager.shared.retrieveImage(with: configuration.imageURL, completionHandler: { result in
            switch result {
            case .success(let value):
                self.scrollView.image = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }
}
