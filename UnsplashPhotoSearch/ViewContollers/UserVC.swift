//
//  UserDetailsVC.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit
import Kingfisher

class UserVC: UIViewController {
    let userInfoView = UserInfoView()
    let userMediaView = UserMediaView()

    let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension UserVC {
    func setup() {
        view.backgroundColor = .white
        view.addSubview(userInfoView)
        view.addSubview(userMediaView)

        userInfoView.configuration = .init(
            name: user.name,
            username: user.username,
            imageURL: user.imageURL
        )

        setupConstraints()
    }

    func setupConstraints() {
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userMediaView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            userMediaView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 10),
            userMediaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userMediaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userMediaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }
}

