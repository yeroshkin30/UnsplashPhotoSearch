//
//  PhotoView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 05.04.2023.
//

import UIKit
import Kingfisher
import SnapKit

class PhotoView: UIView {
    private lazy var scrollView: PhotoScrollView = .init(frame: bounds)
    private let infoButton: UIButton = .init()
    private let likeButton: UIButton = .init()


    private var photoIsLiked: Bool = false

    var configuration: Configuration? {
        didSet {
            configurationDidChange(oldValue: oldValue)
        }
    }

    var onButtonEvent: ((ButtonTapped) -> Void)?


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(scrollView)
        addSubview(likeButton)
        addSubview(infoButton)
        backgroundColor = .white

        setupLikeButton()

        infoButton.configuration = likeButton.configuration
        infoButton.configuration?.image = UIImage(systemName: "info.circle.fill")
        infoButton.configuration?.baseForegroundColor = .gray
        infoButton.addAction(
            UIAction { _ in self.onButtonEvent?(.info) },
            for: .touchUpInside
        )

        setupConstraints()
    }

    func setupLikeButton() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.imagePlacement = .top
        config.imagePadding = 5

        config.baseForegroundColor = .red
        config.preferredSymbolConfigurationForImage = .init(pointSize: 25)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseBackgroundColor = .clear
        likeButton.configuration = config
//        likeButton.configurationUpdateHandler = { button in
//            var config = button.configuration
//            config?.image = self.photoIsLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
//            button.isSelected = self.photoIsLiked
//            button.configuration = config
//        }
        likeButton.addAction(
            UIAction { _ in self.onButtonEvent?(.like(self.photoIsLiked)) },
            for: .touchUpInside
        )
    }


    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        infoButton.snp.makeConstraints { maker in
            maker.top.equalTo(likeButton)
            maker.left.equalToSuperview().offset(5)
        }

        likeButton.snp.makeConstraints { maker in
            maker.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-15)
            maker.right.equalToSuperview().offset(-5)
        }
    }
}

extension PhotoView {
    struct Configuration {
        let numberOfLikes: Int
        let imageURL: URL
        let placeholder: UIImage?
        let isLiked: Bool

        init(photo: Photo) {
            numberOfLikes = photo.likes ?? 0
            imageURL = photo.photoURL.regular
            placeholder = UIImage.blurHash(from: photo)
            isLiked = photo.isLiked
        }
    }
}

private extension PhotoView {
    func configurationDidChange(oldValue: Configuration?) {
        guard let configuration else { return }
        photoIsLiked = configuration.isLiked
        
        likeButton.configuration?.title = "\(configuration.numberOfLikes)"
        likeButton.configuration?.image = self.photoIsLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
//        scrollView.image = configuration.placeholder

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

extension PhotoView {
    enum ButtonTapped {
        case like(Bool)
        case info
    }
}
