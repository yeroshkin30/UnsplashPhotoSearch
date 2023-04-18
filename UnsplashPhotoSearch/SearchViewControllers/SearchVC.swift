
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher


final class SearchVC: UIViewController, UISearchBarDelegate {
    private let searchController: UISearchController = .init()
    private let pagingScrollView: UIScrollView = .init()
    let stackView: UIStackView = .init()


    private let photosDataRequestController = DataRequestController<Photo>(category: "photos")
    private let collectionsDataRequestController = DataRequestController<Collection>(category: "collections")
    private let usersDataRequestController = DataRequestController<User>(category: "users")

    lazy private var photosSearchVC: PhotosSearchVC = .init(controller: photosDataRequestController )
    lazy private var collectionsSearchVC: CollectionsSearchVC = .init(controller: collectionsDataRequestController)
    lazy private var usersSearchVC: UsersSearchVC = .init(controller: usersDataRequestController)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeSearchWord()
    }

    func changeSearchWord() {
        let word = "ocean"

        photosSearchVC.searchWordDidChange(word)
        collectionsSearchVC.searchWordDidChange(word)
        usersSearchVC.searchWordDidChange(word)
    }

    // searchControllerDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        changeSearchWord()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        changeSearchWord()
        let width = view.frame.width
        switch selectedScope {
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

//UISetup
private extension SearchVC {
    func setup() {
        view.backgroundColor = .white
        view.addSubview(pagingScrollView)

        setupSearchController()
        setupChildVC()
        scrollViewSetup()
        setupConstraints()
    }

    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true

        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
        searchController.searchBar.searchTextField.addAction(
            UIAction { _ in self.changeSearchWord() },
            for: .valueChanged
        )
        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)
    }

    func setupChildVC() {
        addChild(photosSearchVC)
        addChild(collectionsSearchVC)
        addChild(usersSearchVC)

        photosSearchVC.didMove(toParent: self)
        collectionsSearchVC.didMove(toParent: self)
        usersSearchVC.didMove(toParent: self)
    }

    func scrollViewSetup() {
        pagingScrollView.addSubview(stackView)
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.isScrollEnabled = false

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(photosSearchVC.view)
        stackView.addArrangedSubview(collectionsSearchVC.view)
        stackView.addArrangedSubview(usersSearchVC.view)
    }

    func setupConstraints() {
        pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pagingScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pagingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: pagingScrollView.contentLayoutGuide.bottomAnchor),

            photosSearchVC.view.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            photosSearchVC.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),

        ])

    }


}
