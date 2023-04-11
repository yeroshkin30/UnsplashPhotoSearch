
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
   
    let searchView: SearchView = .init()
    private let dataSearchController = SearchController(configuration: .init(word: "panda", category: .photos))

    let searchCategory = ["photos", "collections", "users"]
    var searchTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchMatchingItems()
    }

    @objc func fetchMatchingItems() {
        dataSearchController.configuration = .init(
            word: "panda",
            category: SearchCategory(rawValue: searchCategory[searchController.searchBar.selectedScopeButtonIndex])!
        )

        searchTask?.cancel()
        searchTask = Task {
            do {
                try await dataSearchController.loadNextPage()
                searchView.collectionView.collectionViewLayout = dataSearchController.createLayout()
                searchView.collectionView.reloadData()

            } catch {
                print(error)
            }

            searchTask?.cancel()
        }
    }

    // searchControllerDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        perform(#selector(fetchMatchingItems), with: nil)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        fetchMatchingItems()
    }
}

//UISetup
private extension SearchViewController {
    func handleSearchControllerEvent(_ event: SearchController.Event) {
        switch event {
        case .photoSelected(let photo):
            let photoVC = PhotoViewController(photo: photo)
            self.show(photoVC, sender: nil)
        case .collectionSelected(let collection):
            let collectionVC = CollectionPhotosViewController(photoUrl: collection.photosURL)
            self.show(collectionVC, sender: nil)
        case .userSelected(let user):
            let userVC = UserViewController(user: user)
            self.show(userVC, sender: nil)
        case .sectionsInserted(let indexes):
            self.searchView.collectionView.insertSections(IndexSet(indexes))
        case .itemsInserted(let indexes):
            let indexes = indexes.map { IndexPath(item: $0, section: 0)}
            self.searchView.collectionView.insertItems(at: indexes)
        }
    }

    func setupEvents () {
        dataSearchController.onEvent = { [unowned self] event in
            self.handleSearchControllerEvent(event)
        }
    }

    func setup() {
        view.addSubview(searchView)
        view.backgroundColor = .white

        searchView.collectionView.delegate = dataSearchController
        searchView.collectionView.dataSource = dataSearchController
        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true

        searchController.searchBar.scopeButtonTitles = ["Photos","Collections", "Users"]
        searchController.searchBar.searchTextField.addAction(
            UIAction { _ in
                self.fetchMatchingItems()
                self.searchView.collectionView.reloadData()

            },
            for: .valueChanged
        )
        searchController.searchBar.layer.backgroundColor = .init(gray: 10, alpha: 1)

        setupEvents()
        setupConstraints()
    }
    
    func setupConstraints() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    
}
