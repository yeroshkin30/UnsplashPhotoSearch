//
//  UserDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit
import SnapKit

class UserInfoView: UIView {
    private let usernameLabel: UILabel = .init()
    private let nameLabel: UILabel = .init()
    private let profileImage: UIImageView = .init()

    private let userDataStackView: UIStackView = .init()
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
        addSubview(userDataStackView)

        setupLabels()
        setupStackViews()
        setupConstraints()
    }

    private func configurationDidChange() {
        guard let configuration else { return }
        
        usernameLabel.text = configuration.username
        nameLabel.text = configuration.name
        profileImage.kf.setImage(with: configuration.imageURL)
    }

    private func setupLabels() {
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.font = UIFont.systemFont(ofSize: 20)
    }

    private func setupStackViews() {
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(usernameLabel)
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 10

        userDataStackView.addArrangedSubview(profileImage)
        userDataStackView.addArrangedSubview(labelStackView)
        userDataStackView.axis = .horizontal
        userDataStackView.alignment = .leading
        userDataStackView.distribution = .fill
        userDataStackView.spacing = 10
    }

    private func setupConstraints() {
        userDataStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UserInfoView {
    struct Configuration {
        let name: String
        let username: String
        let imageURL: URL
    }
}
