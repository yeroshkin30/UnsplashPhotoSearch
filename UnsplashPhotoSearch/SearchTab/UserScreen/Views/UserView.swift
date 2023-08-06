//
//  UserDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit

final class UserView: UIView {

    var onSegmentChanged: ((Int) -> Void)?
    var configuration: Configuration? {
        didSet {
            configurationDidChange()
        }
    }
    let containerView: UIView = .init()

    // MARK: - Private properties

    private let profileImage: UIImageView = .init()
    private let usernameLabel: UILabel = .init()
    private let nameLabel: UILabel = .init()
    private let labelsStackView: UIStackView = .init()
    private let mediaSegmentedControl: UISegmentedControl = .init()
    private let topStackView: UIStackView = .init()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectedIndex() -> Int {
        mediaSegmentedControl.selectedSegmentIndex
    }
}

// MARK: - Private methods

extension UserView {

    func setup() {
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true

        setupLabels()
        setupStackView()
        setupConstraints()
    }

    func setupLabels() {
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.font = UIFont.systemFont(ofSize: 20)
    }

    func setupStackView() {
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(usernameLabel)
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 10
    }

    func setupTopStackView() {
        topStackView.addArrangedSubview(profileImage)
        topStackView.addArrangedSubview(labelsStackView)
    }

    func segmentControlSetup() {
        mediaSegmentedControl.insertSegment(withTitle: "Photos", at: 0, animated: false)
        mediaSegmentedControl.insertSegment(withTitle: "Likes", at: 1, animated: false)
        mediaSegmentedControl.insertSegment(withTitle: "Collections", at: 2, animated: false)
        mediaSegmentedControl.selectedSegmentIndex = 0
        mediaSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        onSegmentChanged?(sender.selectedSegmentIndex)
    }

    func setupConstraints() {
        topStackView.layout(in: self) {
            $0.top == safeAreaLayoutGuide.topAnchor + Margins.standard
            $0.leading == leadingAnchor + Margins.standard
            $0.trailing == trailingAnchor - Margins.standard
            $0.height == 120
        }

        profileImage.layout { $0.width == $0.height }

        mediaSegmentedControl.layout(in: self) {
            $0.top == topStackView.bottomAnchor + Margins.standard
            $0.leading == leadingAnchor + Margins.standard
            $0.trailing == trailingAnchor - Margins.standard
            $0.height == 30
        }

        containerView.layout(in: self) {
            $0.top == mediaSegmentedControl.bottomAnchor + Margins.standard
            $0.leading == leadingAnchor + Margins.standard
            $0.trailing == trailingAnchor - Margins.standard
            $0.bottom == bottomAnchor
        }
    }
}

extension UserView {
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
