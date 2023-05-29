//
//  UserDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit
import SnapKit

class UserInfoView: UIView {
    private let profileImage: UIImageView = .init()
    private let usernameLabel: UILabel = .init()
    private let nameLabel: UILabel = .init()
    private let labelStackView: UIStackView = .init()

    var configuration: Configuration? {
        didSet {
            configurationDidChange()
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
        addSubview(profileImage)
        addSubview(labelStackView)

        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true

        setupLabels()
        setupStackView()
        setupConstraints()
    }

    private func setupLabels() {
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.font = UIFont.systemFont(ofSize: 20)
    }

    private func setupStackView() {
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(usernameLabel)
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 10
    }

    private func setupConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(profileImage.snp.height)
        }
        labelStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.leading.equalTo(profileImage.snp.trailing).offset(5)
        }
    }
}

extension UserInfoView {
    private func configurationDidChange() {
        guard let configuration else { return }

        usernameLabel.text = configuration.username
        nameLabel.text = configuration.name
        profileImage.kf.setImage(with: configuration.imageURL)
    }

    struct Configuration {
        let name: String
        let username: String
        let imageURL: URL
    }
}
