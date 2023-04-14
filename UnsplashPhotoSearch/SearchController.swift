//
//  SearchController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

enum SearchCategory: String {
    case photos
    case collections
    case users
}

class SearchController<SearchItem: Codable> {
    
    private var searchItems: [SearchItem] = []
    private var currentPage: Int = 0
    private var category: String
    var searchWord: String? {
        didSet {
            currentPage = 0
        }
    }

    init(category: String) {
        self.category = category
    }

    private func request(currentPage: Int) -> URLRequest {
        URLRequest(
            path: category,
            queryItems: Array.pageQueryItems(searchWord: searchWord!, page: currentPage)
        )
    }
    //actor
    func loadNextPage() async throws -> [SearchItem] {
        currentPage += 1
        let urlRequest = request(currentPage: currentPage)

        let searchItems = try await APIRequest<SearchItem>().sendRequest(with: urlRequest)
        self.searchItems = searchItems

        return searchItems
    }
}
//    extension SearchController {
//        struct SearchConfiguration {
//            let word: String
//            let category: SearchCategory
//
//            func request(currentPage: Int) -> URLRequest {
//                URLRequest(
//                    path: category.rawValue,
//                    queryItems: Array.pageQueryItems(searchWord: word, page: currentPage)
//                )
//            }
//        }
//    }
//var configuration: SearchConfiguration {
//    didSet {
//        configurationDidChange()
//    }
//}

//    //DELEGATE
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch configuration.category {
//        case .photos:
//            let photo = photoSearchData[indexPath.item]
//            onEvent?(.photoSelected(photo))
//        case .collections:
//            let collection = collectionSearchData[indexPath.section]
//            onEvent?(.collectionSelected(collection))
//        case .users:
//            let user = userSearchData[indexPath.item]
//            onEvent?(.userSelected(user))
//        }
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        willDisplay cell: UICollectionViewCell,
//        forItemAt indexPath: IndexPath
//    ) {
//        var startIndex: Int
//        var lefted: Int
//
//        switch configuration.category {
//        case .photos:
//            startIndex = photoSearchData.count
//            lefted = photoSearchData.count - indexPath.item
//        case .collections:
//            startIndex = collectionSearchData.count
//            if indexPath.item == 0 {
//                lefted = collectionSearchData.count - indexPath.section
//            } else {
//                lefted = 5
//            }
//        case .users:
//            startIndex = userSearchData.count
//            lefted = userSearchData.count - indexPath.item
//        }
//
//        let itemRange = Array(startIndex...startIndex + 29)
//
//        if lefted == 25 {
//
//            Task {
//                do {
//                    try await loadNextPage()
//
//                    switch configuration.category {
//                    case .collections:
//                        self.onEvent?(.sectionsInserted(itemRange))
//                    default:
//                        self.onEvent?(.itemsInserted(itemRange))
//                    }
//                } catch {
//                    print(error)
//                }
//
//            }
//        }
//    }
//}

// MARK: - Internal Types

