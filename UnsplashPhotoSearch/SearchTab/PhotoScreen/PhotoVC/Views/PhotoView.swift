//
//  PhotoView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 05.04.2023.
//

import UIKit
import Kingfisher

final class PhotoView: UIView {

    enum ButtonType {
        case like
        case info
    }
    
    var onButtonTap: ((ButtonType) -> Void)?
    var configuration: Configuration? {
        didSet {
            configurationDidChange()
        }
    }
    
    // MARK: - Private properties

    private lazy var scrollView: PhotoScrollView = .init(frame: bounds)
    private let imageView: UIImageView = .init()

    private let infoButton: UIButton = .init(configuration: .clear())
    private let likeButton: UIButton = .init(configuration: .clear())
    private var photoIsLiked: Bool = false
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension PhotoView {

    func setup() {
        backgroundColor = .white

        setupButtons()
        setupConstraints()
    }

    func setupButtons() {
        likeButton.configuration?.baseForegroundColor = .red
        likeButton.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 25)
        likeButton.configuration?.imagePlacement = .trailing
        likeButton.configurationUpdateHandler = { button in
            button.configuration?.image = button.state == .normal
            ? UIImage(systemName: "heart")
            : UIImage(systemName: "heart.fill")
        }
        likeButton.onTapEvent { [weak self] in
            self?.likeButton.isSelected.toggle()
            self?.onButtonTap?(.like)
        }

        infoButton.configuration?.preferredSymbolConfigurationForImage = .init(pointSize: 25)
        infoButton.configuration?.baseForegroundColor = .gray
        infoButton.configuration?.image = UIImage(systemName: "info.circle.fill")
        likeButton.onTapEvent { [weak self] in
            self?.onButtonTap?(.info)
        }
    }

    func setupConstraints() {
        scrollView.layout(in: self)
        
        likeButton.layout(in: self) {
            $0.bottom == safeAreaLayoutGuide.bottomAnchor - Margins.standard2x
            $0.trailing == trailingAnchor - Margins.standard
        }
        
        infoButton.layout(in: self) {
            $0.centerY == likeButton.centerYAnchor
            $0.leading == leadingAnchor + Margins.standard
        }
    }

    func configurationDidChange() {
        guard let configuration else { return }

        photoIsLiked = configuration.isLiked
        likeButton.isSelected = configuration.isLiked
        likeButton.configuration?.title = "\(configuration.numberOfLikes)"

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

