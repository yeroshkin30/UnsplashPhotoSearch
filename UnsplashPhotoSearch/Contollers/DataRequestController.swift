//
//  SearchController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

class DataRequestController<SearchItem: Codable> {
    
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

        let searchItems = try await SearchRequest<SearchItem>().sendRequest(with: urlRequest)
        self.searchItems = searchItems

        return searchItems
    }
}


