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
    private let userInfoView = UserInfoView()
    private let mediaSegmentedControl: UISegmentedControl = .init()
    
    private let pagingScrollView: UIScrollView = .init()
    private let stackView: UIStackView = .init()

    lazy var photosController: UserMediaController<Photo> = .init(.photos(user.username))
    lazy var likesController: UserMediaController<Photo> = .init(.likes(user.username))
    lazy var collectionsController: UserMediaController<Collection> = .init(.collections(user.username))
    
    lazy var userPhotosVC: UserPhotosVC = .init(controller: photosController)
    lazy var userLikesVC: UserLikesVC = .init(controller: likesController)
    lazy var userCollectionsVC: UserCollectionsVC = .init(controller: collectionsController)

    var user: User {
        didSet {
            userInfoView.configuration = .init(
                name: user.name,
                username: user.username,
                imageURL: user.imageURL
            )
        }
    }

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

    @objc func segmentDidChange(_ sender: UISegmentedControl) {
        let width = view.frame.width
        switch sender.selectedSegmentIndex {
        case 0:
            pagingScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            pagingScrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
        case 2:
            pagingScrollView.setContentOffset(CGPoint(x: width * 2, y: 0), animated: true)
        default:
            return
        }
    }
}

private extension UserVC {
    func setup() {
        view.backgroundColor = .systemGray6
        view.addSubview(userInfoView)
        view.addSubview(mediaSegmentedControl)
        view.addSubview(pagingScrollView)

        userInfoView.configuration = .init(
            name: user.name,
            username: user.username,
            imageURL: user.imageURL
        )

        setupChildVC()
        segmentControlSetup()
        scrollViewSetup()
        setupConstraints()
    }

    func segmentControlSetup() {
        mediaSegmentedControl.insertSegment(withTitle: "Photos", at: 0, animated: false)
        mediaSegmentedControl.insertSegment(withTitle: "Likes", at: 1, animated: false)
        mediaSegmentedControl.insertSegment(withTitle: "Collections", at: 2, animated: false)
        mediaSegmentedControl.selectedSegmentIndex = 0
        mediaSegmentedControl.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
    }

    func setupChildVC() {
//        addChildVC(userPhotosVC, superView:  stackView)
//        addChildVC(userLikesVC, superView:  stackView)
//        addChildVC(userCollectionsVC, superView:  stackView)
    }

    func scrollViewSetup() {
        pagingScrollView.addSubview(stackView)
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.isScrollEnabled = false

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }

    func setupConstraints() {
        userInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
            make.height.equalTo(120)
        }

        mediaSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        pagingScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(mediaSegmentedControl.snp.bottom).offset(3)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(pagingScrollView.contentLayoutGuide)
        }

        userPhotosVC.view.snp.makeConstraints { make in
            make.height.equalTo(pagingScrollView.snp.height)
            make.width.equalTo(view.snp.width)
        }
    }
}
