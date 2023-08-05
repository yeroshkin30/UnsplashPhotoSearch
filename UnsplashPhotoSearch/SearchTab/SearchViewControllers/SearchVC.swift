
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

    private let searchController: UISearchController = .init()
    private let searchBar: UISearchBar = .init()
    private let containerView: UIView = .init()

    private let dataFetchController: DataFetchController = .shared

    private let photosSearchVC: PhotosSearchVC = .init()
    private let collectionsSearchVC: CollectionsSearchVC = .init()
    private let usersSearchVC: UsersSearchVC = .init()

    var currentChild: UIViewController!

// MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeSearchWord()
    }

    func changeSearchWord() {
        let word = "panda"

        dataFetchController.searchWord = word
        getData()
    }

    func getData() {
        let index = searchController.searchBar.selectedScopeButtonIndex

        Task {
            switch SearchCategory(rawValue: index) {
            case .photos:
                photosSearchVC.photos = await dataFetchController.fetchPhotos()
                
            case .collections:
                collectionsSearchVC.collections = await dataFetchController.fetchCollections()
                
            case .users:
                usersSearchVC.users = await dataFetchController.fetchUsers()
                
            default:
                return
            }
        }
    }
}

// MARK: - Private methods
private extension MainSearchVC {
    func setup() {
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

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
            guard let self else { return }

            switch event {
            case .loadNextPage:
                Task {
                    self.photosSearchVC.photos = await self.dataFetchController.fetchPhotos()
                }
            case .showPhoto(let photo):
                print(photo.id)
            }
        }

        collectionsSearchVC.onEvent = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loadNextPage:
                Task {
                    self.collectionsSearchVC.collections = await self.dataFetchController.fetchCollections()
                }
            case .showCollection(let collection):
                print(collection.id)
            }
        }

        usersSearchVC.onEvent = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loadNextPage:
                Task {
                    self.usersSearchVC.users = await self.dataFetchController.fetchUsers()
                }
            case .showUser(let user):
                print(user.id)
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

extension MainSearchVC: UISearchControllerDelegate {

}


extension MainSearchVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        changeSearchWord()
        switch selectedScope {
        case 0:
            childrenFullScreenAnimatedTransition(from: currentChild, to: collectionsSearchVC)
            currentChild = photosSearchVC

        case 1:
            childrenFullScreenAnimatedTransition(from: currentChild, to: collectionsSearchVC)
            currentChild = collectionsSearchVC
            
        case 2:
            childrenFullScreenAnimatedTransition(from: currentChild, to: collectionsSearchVC)
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





extension UIViewController {
    func childrenFullScreenAnimatedTransition(
        from presented: UIViewController,
        to presenting: UIViewController,
        completion: ((Bool) -> Void)? = nil
    ) {
        assert(presented.parent == self, "Presented view controller should be a child of self", file: #file, line: #line)

        presented.willMove(toParent: nil)
        addChild(presenting)
        presenting.view.alpha = 0
        presenting.view.layout(in: view)
        presenting.didMove(toParent: self)

        UIView.animate(
            withDuration: 0.5,
            animations: {
                presenting.view.alpha = 1
            }, completion: { isFinished in

                presented.view.removeFromSuperview()
                presented.removeFromParent()

                completion?(isFinished)
            }
        )
    }
}
