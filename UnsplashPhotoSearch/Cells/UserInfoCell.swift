//
//  UserInfoCell.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 30.03.2023.
//

import UIKit
import Kingfisher

final class UserInfoCell: UICollectionViewCell {

    var configuration: Configuration? {
        didSet {
            configurationDidChange()
        }
    }

    // MARK: - Private properties

    private let userImageView: UIImageView = .init()
    private let nameLabel: UILabel = .init()
    private let usernameLabel: UILabel = .init()
    private let separatorView: UIView = .init()
    private let stackView: UIStackView = .init()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = (contentView.bounds.height - 3) / 2
    }

    func configure(with userData: User) {
        usernameLabel.text = userData.username
        nameLabel.text = userData.name
        let processor = RoundCornerImageProcessor(cornerRadius: userImageView.bounds.height / 2)

        userImageView.kf.setImage(
            with: userData.imageURL,
            placeholder: UIImage(systemName: "photo"),
            options: [.transition(.fade(0.3)), .processor(processor)]
        )
    }
}

// MARK: - Private methods

private extension UserInfoCell {

    func setupView() {
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        separatorView.backgroundColor = .systemGray2
        
        setupLabels()
        setupStackView()
        setupConstraints()
    }

    func setupLabels() {
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        usernameLabel.textColor = .black
        usernameLabel.font = UIFont.systemFont(ofSize: 11)
    }

    func setupStackView() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(usernameLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
    }

    func setupConstraints() {
        userImageView.layout(in: contentView) {
            $0.top == contentView.topAnchor
            $0.leading == contentView.leadingAnchor
            $0.bottom == contentView.bottomAnchor - 3
            $0.width == $0.height
        }

        stackView.layout(in: contentView) {
            $0.top == contentView.topAnchor
            $0.leading == contentView.leadingAnchor + 50 // WTF?
            $0.trailing == contentView.trailingAnchor
            $0.bottom == contentView.bottomAnchor - 3
        }

        separatorView.layout(in: contentView) {
            $0.leading == contentView.leadingAnchor
            $0.trailing == contentView.trailingAnchor
            $0.bottom == contentView.bottomAnchor
            $0.height == 2
        }
    }
}

extension UserInfoCell {
    func configurationDidChange() {
        guard let configuration else { return }
        nameLabel.text = configuration.name
        usernameLabel.text = configuration.username
        userImageView.image = configuration.image
    }

    struct Configuration {
        let name: String
        let username: String
        let image: UIImage?
    }
}
