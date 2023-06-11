
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchVC: UIViewController {
    private let searchController: UISearchController = .init()
    private let pagingScrollView: UIScrollView = .init()
    private let stackView: UIStackView = .init()
    private let searchBar: UISearchBar = .init()

    private let photosController = DataRequestController<Photo>(category: .photo)
    private let collectionsController = DataRequestController<Collection>(category: .collection)
    private let usersController = DataRequestController<User>(category: .user)

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
//        collectionsSearchVC.searchWordDidChange(word)
//        usersSearchVC.searchWordDidChange(word)
    }

    // searchControllerDelegate
}

extension SearchVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.endEditing(true)
        changeSearchWord()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3){
            searchBar.setShowsCancelButton(false, animated: false)
            searchBar.searchTextField.endEditing(true)
        }
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
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        view.backgroundColor = .white
        view.addSubview(pagingScrollView)

        setupSearchController()
        setupChildVC()
        scrollViewSetup()
        setupConstraints()
    }

    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .never
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]

        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)


//        searchBar.delegate = self
//        searchBar.searchBarStyle = .minimal
//        searchBar.showsScopeBar = true
//        searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
//        searchBar.searchTextField.addAction(
//            UIAction { _ in self.changeSearchWord() },
//            for: .valueChanged
//        )
//        searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)
//
//        navigationItem.titleView = searchBar
//
    }

    func setupChildVC() {
        addChildVC(photosSearchVC, superView: stackView)
        addChildVC(collectionsSearchVC, superView: stackView)
        addChildVC(usersSearchVC, superView: stackView)
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
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
