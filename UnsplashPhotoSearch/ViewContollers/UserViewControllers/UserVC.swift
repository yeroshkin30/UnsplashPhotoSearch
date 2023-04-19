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
    let userMediaSegmentControl = UserMediaSegmentControl()
    
    private let pagingScrollView: UIScrollView = .init()
    private let stackView: UIStackView = .init()

    lazy var userPhotosController: UserMediaController<Photo> = .init(type: .photos(user.username))
    lazy var userLikesController: UserMediaController<Photo> = .init(type: .likes(user.username))
    lazy var userCollectionsController: UserMediaController<Collection> = .init(type: .collections(user.username))
    
    lazy var userPhotosVC: UserPhotosVC = .init(controller: userPhotosController, total: user.totalPhotos)
    lazy var userLikesVC: UserLikesVC = .init(controller: userPhotosController, total: user.totalLikes)
    lazy var userCollectionsVC: UserCollectionsVC = .init(controller: userCollectionsController, total: user.totalCollections)

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
        view.addSubview(userMediaSegmentControl)
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
        userMediaSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            userMediaSegmentControl.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 10),
            userMediaSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userMediaSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userMediaSegmentControl.heightAnchor.constraint(equalToConstant: 30),

            pagingScrollView.topAnchor.constraint(equalTo: userMediaSegmentControl.bottomAnchor, constant: 3),
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

extension UserVC {
    enum MediaType {
        case photos(_ username: String)
        case likes(_ username: String)
        case collections(_ username: String)

        var type: String {
            switch self {
            case .photos(_):
                return "photos"
            case .likes(_):
                return "likes"
            case .collections(_):
                return "collections"
            }
        }
    }

    struct MediasType {
        let type: String
        let username: String
    }
}

