//
//  UserDetailsVC.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit
import Kingfisher
import SnapKit

final class UserVC: UIViewController {

    enum Event {
        case showPhoto(Photo)
        case showCollection(Collection)
        case showUser(User)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties
    private let mainView: UserView = .init()
    private let dataFetchController: UserFetchController = .shared

    private let photosVC: PhotosVC = .init()
    private let likesVC: PhotosVC = .init()
    private let collectionsVC: CollectionsVC = .init()
    private var currentChild: UIViewController!

    // MARK: - Inits

    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeSearchWord()
    }

    func changeSearchWord() {
        let word = "panda"

        dataFetchController.searchWord = word
        Task {
            do {
                photosVC.photos = try await dataFetchController.fetchItems(type: .photos)
                likesVC.photos = try await dataFetchController.fetchItems(type: .likes)
                collectionsVC.collections = try await dataFetchController.fetchItems(type: .collections)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Private methods
private extension UserVC {

    func fetchItems() {
        let index = mainView.selectedIndex()
        Task {
            switch MediaCategory(rawValue: index) {
            case .photos:
                photosVC.photos = await dataFetchController.fetchPhotos()
            case .collections:
                collectionsVC.collections = await dataFetchController.fetchCollections()
            case .users:
                likesVC.photos = await dataFetchController.fetchPhotos()
            default:
                return
            }
        }
    }

    func setup() {
        mainView.configuration = .init(
            name: user.name,
            username: user.username,
            imageURL: user.imageURL
        )
        mainView.onSegmentChanged = { [weak self] index in
            self?.segmentIndexChanged(index: index)
        }

        setupChildVC()
    }


    func setupChildVC() {
        addChild(controller: photosVC, rootView: mainView.containerView)
        currentChild = photosVC

        photosVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.fetchItems()
            case .showPhoto(let photo):
                self?.onEvent?(.showPhoto(photo))
            }
        }

        collectionsVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.fetchItems()
            case .showCollection(let collection):
                self?.onEvent?(.showCollection(collection))
            }
        }

        likesVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.fetchItems()
            case .showPhoto(let photo):
                self?.onEvent?(.showPhoto(photo))
            }
        }
    }

    func segmentIndexChanged(index: Int) {
        switch MediaCategory(rawValue: index) {
        case .photos:
            childrenFullScreenAnimatedTransition(from: currentChild, to: photosVC)
            currentChild = photosVC

        case .collections:
            childrenFullScreenAnimatedTransition(from: currentChild, to: collectionsVC)
            currentChild = collectionsVC

        case .users:
            childrenFullScreenAnimatedTransition(from: currentChild, to: likesVC)
            currentChild = likesVC

        default:
            return
        }
    }
}

private extension UserVC {
    enum MediaCategory: Int {
        case photos
        case collections
        case users
    }
}
var user: User {
    didSet {
        mainView.configuration = .init(
            name: user.name,
            username: user.username,
            imageURL: user.imageURL
        )
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
