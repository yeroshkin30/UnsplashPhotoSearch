
//
//  SearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit
import Kingfisher
import SnapKit

final class MainSearchVC: UIViewController {

    enum Event {
        case showPhoto(Photo)
        case showCollection(Collection)
        case showUser(User)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties
    private let searchController: UISearchController = .init()
    private let searchBar: UISearchBar = .init()
    private let containerView: UIView = .init()

    private let dataFetchController: DataFetchController = .shared

    private let photosSearchVC: PhotosVC = .init()
    private let collectionsSearchVC: CollectionsVC = .init()
    private let usersSearchVC: UsersVC = .init()

    private var currentChild: UIViewController!

// MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeSearchWord()
    }

    func changeSearchWord() {
        let word = "panda"
        
        dataFetchController.searchWord = word
        Task { /// if One fails, all fail
            do {
                photosSearchVC.photos = try await dataFetchController.fetchPhotos()
                collectionsSearchVC.collections = try await dataFetchController.fetchCollections()
                usersSearchVC.users = try await dataFetchController.fetchUsers()
            } catch {
                print(error)
            }
        }
    }

    func fetchItems() {
        let index = searchController.searchBar.selectedScopeButtonIndex

        Task {
            do {
                switch SearchCategory(rawValue: index) {
                case .photos:
                    photosSearchVC.photos = try await dataFetchController.fetchPhotos()
                case .collections:
                    collectionsSearchVC.collections = try await dataFetchController.fetchCollections()
                case .users:
                    usersSearchVC.users = try await dataFetchController.fetchUsers()
                default:
                    return
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Private methods
private extension MainSearchVC {
    func setup() {
        view.backgroundColor = .white

        setupSearchController()
        setupChildVC()
        setupConstraints()
    }

    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .never
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)
    }

    func setupChildVC() {
        addChild(controller: photosSearchVC, rootView: containerView)
        currentChild = photosSearchVC

        photosSearchVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.fetchItems()
            case .showPhoto(let photo):
                self?.onEvent?(.showPhoto(photo))
            }
        }

        collectionsSearchVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.fetchItems()
            case .showCollection(let collection):
                self?.onEvent?(.showCollection(collection))
            }
        }

        usersSearchVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.fetchItems()
            case .showUser(let user):
                self?.onEvent?(.showUser(user))
            }
        }
    }

    func setupConstraints() {
        containerView.layout(in: view) {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
        }
    }
}



extension MainSearchVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch SearchCategory(rawValue: selectedScope) {
        case .photos:
            childrenFullScreenAnimatedTransition(from: currentChild, to: photosSearchVC)
            currentChild = photosSearchVC

        case .collections:
            childrenFullScreenAnimatedTransition(from: currentChild, to: collectionsSearchVC)
            currentChild = collectionsSearchVC

        case .users:
            childrenFullScreenAnimatedTransition(from: currentChild, to: usersSearchVC)
            currentChild = usersSearchVC

        default:
            return
        }
    }

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
}

extension MainSearchVC {
    enum SearchCategory: Int {
        case photos
        case collections
        case users
    }
}
