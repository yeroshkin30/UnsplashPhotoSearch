//
//  UserDetailsVC.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit
import Kingfisher
import SnapKit

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

        stackView.addArrangedSubview(userPhotosVC.view)
        stackView.addArrangedSubview(userLikesVC.view)
        stackView.addArrangedSubview(userCollectionsVC.view)

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

    }

    func setupConstraints() {
        userInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 15, left: 8, bottom: 0, right: 8))
        }

        userMediaSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        pagingScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(userMediaSegmentControl.snp.bottom).offset(3)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(pagingScrollView.contentLayoutGuide)
        }

        userPhotosVC.view.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.width.equalTo(view.snp.width)
        }
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

