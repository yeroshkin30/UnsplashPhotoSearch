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
    let userMediaSegmentControll = UserMediaSegmentControll()
    
    private let pagingScrollView: UIScrollView = .init()
    private let stackView: UIStackView = .init()

    lazy var userPhotosMediaController: UserMediaController<Photo> = .init(mediatype: "photos", username: user.username)
    lazy var userLikesMediaController: UserMediaController<Photo> = .init(mediatype: "likes", username: user.username)
    lazy var userCollectionsMediaController: UserMediaController<Collection> = .init(mediatype: "collections", username: user.username)
    
    lazy var userPhotosVC: UserPhotosVC = .init(controller: userPhotosMediaController, total: user.totalPhotos)
    lazy var userLikesVC: UserLikesVC = .init(controller: userPhotosMediaController, total: user.totalLikes)
    lazy var userCollectionsVC: UserCollectionsVC = .init(controller: userCollectionsMediaController, total: user.totalCollections)


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
        view.addSubview(userMediaSegmentControll)
        view.addSubview(pagingScrollView)

        userInfoView.configuration = .init(
            name: user.name,
            username: user.username,
            imageURL: user.imageURL
        )
        setupChildVC()
        scrollViewSetup()
        setupConstraints()
    }

    func setupChildVC() {
        addChild(userPhotosVC)
        addChild(userLikesVC)
        addChild(userCollectionsVC)

        userPhotosVC.didMove(toParent: self)
        userLikesVC.didMove(toParent: self)
        userCollectionsVC.didMove(toParent: self)
    }

    func scrollViewSetup() {
        pagingScrollView.addSubview(stackView)
//        pagingScrollView.isPagingEnabled = true
//        pagingScrollView.isScrollEnabled = false

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(userPhotosVC.view)
        stackView.addArrangedSubview(userLikesVC.view)
        stackView.addArrangedSubview(userCollectionsVC.view)
    }

    func setupConstraints() {
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userMediaSegmentControll.translatesAutoresizingMaskIntoConstraints = false
        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            userMediaSegmentControll.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 10),
            userMediaSegmentControll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userMediaSegmentControll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userMediaSegmentControll.heightAnchor.constraint(equalToConstant: 30),

            pagingScrollView.topAnchor.constraint(equalTo: userMediaSegmentControll.bottomAnchor, constant: 3),
            pagingScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pagingScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pagingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.bottomAnchor),

            userPhotosVC.view.heightAnchor.constraint(equalToConstant: 500),
            userPhotosVC.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),

        ])
    }
}

