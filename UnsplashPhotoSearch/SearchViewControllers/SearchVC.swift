
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher


class SearchVC: UIViewController, UISearchBarDelegate {
    private let searchController: UISearchController = .init()

    private let photosSearchController = DataRequestController<Photo>(category: "photos")
    private let collectionsSearchController = DataRequestController<Collection>(category: "collections")
    private let usersSearchController = DataRequestController<User>(category: "users")

    lazy private var photosSearchVC: PhotosSearchVC = .init(controller: photosSearchController )
    lazy private var collectionsSearchVC: CollectionsSearchVC = .init(controller: collectionsSearchController)
    lazy private var usersSearchVC: UsersSearchVC = .init(controller: usersSearchController)

    enum Category: Int {
        case photos
        case collections
        case users
    }

    var chosenCategory = Category.photos

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupSearchWord()
    }


    @objc func setupSearchWord() {
        let word = "panda"

        photosSearchVC.searchWordDidChange(word)
        collectionsSearchVC.searchWordDidChange(word)
        usersSearchVC.searchWordDidChange(word)
    }

    // searchControllerDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        perform(#selector(setupSearchWord), with: nil)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchCategoryChanged()

        setupSearchWord()
    }


    func searchCategoryChanged() {
        let index = searchController.searchBar.selectedScopeButtonIndex
        chosenCategory = Category(rawValue: index)!
        switch chosenCategory {
        case .photos:
            hideViewController(photosSearchVC)
        case .collections:
            hideViewController(collectionsSearchVC)
        case .users:
            hideViewController(usersSearchVC)
        }
    }

    func hideViewController(_ vc: UIViewController) {
        photosSearchVC.view.isHidden = true
        collectionsSearchVC.view.isHidden = true
        usersSearchVC.view.isHidden = true
        vc.view.isHidden = false
    }
}

//UISetup
private extension SearchVC {
    func setup() {
        view.backgroundColor = .white

        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true

        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
        searchController.searchBar.searchTextField.addAction(
            UIAction { _ in
                self.setupSearchWord()


            },
            for: .valueChanged
        )
        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)

        setupChildVC()
        setupConstraints()
    }

    func setupChildVC() {
        addChild(photosSearchVC)
        addChild(collectionsSearchVC)
        addChild(usersSearchVC)

        view.addSubview(photosSearchVC.view)
        view.addSubview(collectionsSearchVC.view)
        view.addSubview(usersSearchVC.view)

        photosSearchVC.didMove(toParent: self)
        collectionsSearchVC.didMove(toParent: self)
        usersSearchVC.didMove(toParent: self)

        collectionsSearchVC.view.isHidden = true
        usersSearchVC.view.isHidden = true
    }
    
    func setupConstraints() {
        photosSearchVC.view.translatesAutoresizingMaskIntoConstraints = false
        collectionsSearchVC.view.translatesAutoresizingMaskIntoConstraints = false
        usersSearchVC.view.translatesAutoresizingMaskIntoConstraints = false

        [photosSearchVC, usersSearchVC, collectionsSearchVC].forEach {
            NSLayoutConstraint.activate([
                $0.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                $0.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                $0.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }

    
}
