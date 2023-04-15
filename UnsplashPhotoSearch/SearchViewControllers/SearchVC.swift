
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher


class SearchViewController: UIViewController, UISearchBarDelegate {
    private let searchController: UISearchController = .init()

    private let photosSearchController = DataRequestController<Photo>(category: "photos")
    private let collectionsSearchController = DataRequestController<Collection>(category: "collections")
    private let usersSearchController = DataRequestController<User>(category: "users")

    lazy private var photosSearchViewController: PhotosSearchViewController = .init(controller: photosSearchController )
    lazy private var collectionsSearchViewController: CollectionsSearchViewController = .init(controller: collectionsSearchController)
    lazy private var usersSearchViewController: UsersSearchViewController = .init(controller: usersSearchController)

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

        photosSearchViewController.searchWord = word
        collectionsSearchViewController.searchWord = word
        usersSearchViewController.searchWord = word

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
            hideViewController(photosSearchViewController)
        case .collections:
            hideViewController(collectionsSearchViewController)
        case .users:
            hideViewController(usersSearchViewController)
        }
    }

    func hideViewController(_ vc: UIViewController) {
        photosSearchViewController.view.isHidden = true
        collectionsSearchViewController.view.isHidden = true
        usersSearchViewController.view.isHidden = true
        vc.view.isHidden = false
    }
}

//UISetup
private extension SearchViewController {
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
        addChild(photosSearchViewController)
        addChild(collectionsSearchViewController)
        addChild(usersSearchViewController)

        view.addSubview(photosSearchViewController.view)
        view.addSubview(collectionsSearchViewController.view)
        view.addSubview(usersSearchViewController.view)

        photosSearchViewController.didMove(toParent: self)
        collectionsSearchViewController.didMove(toParent: self)
        usersSearchViewController.didMove(toParent: self)

        collectionsSearchViewController.view.isHidden = true
        usersSearchViewController.view.isHidden = true
    }
    
    func setupConstraints() {
        photosSearchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        collectionsSearchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        usersSearchViewController.view.translatesAutoresizingMaskIntoConstraints = false

        [photosSearchViewController, usersSearchViewController, collectionsSearchViewController].forEach {
            NSLayoutConstraint.activate([
                $0.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                $0.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                $0.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                $0.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }

    
}
