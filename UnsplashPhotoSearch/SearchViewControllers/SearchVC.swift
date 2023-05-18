
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchVC: UIViewController, UISearchBarDelegate {
    private let searchController: UISearchController = .init()
    private let pagingScrollView: UIScrollView = .init()
    let stackView: UIStackView = .init()


    private let photosController = DataRequestController<Photo>(category: Category.photos.rawValue)
    private let collectionsController = DataRequestController<Collection>(category: Category.collections.rawValue)
    private let usersController = DataRequestController<User>(category: Category.users.rawValue)

    lazy private var photosSearchVC: PhotosSearchVC = .init(controller: photosController )
    lazy private var collectionsSearchVC: CollectionsSearchVC = .init(controller: collectionsController)
    lazy private var usersSearchVC: UsersSearchVC = .init(controller: usersController)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeSearchWord()
    }

    func changeSearchWord() {
        let word = "panda"

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

        stackView.addArrangedSubview(photosSearchVC.view)
        stackView.addArrangedSubview(collectionsSearchVC.view)
        stackView.addArrangedSubview(usersSearchVC.view)
        
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

    }

    func setupConstraints() {
        pagingScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom)
        }

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(pagingScrollView.contentLayoutGuide)
        }

        photosSearchVC.view.snp.makeConstraints { make in
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
    }
}

extension SearchVC {
    enum Category: String {
        case photos
        case collections
        case users
    }
}
