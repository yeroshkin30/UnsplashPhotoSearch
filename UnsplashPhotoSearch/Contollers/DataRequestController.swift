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

    //actor
    func loadNextPage() async throws -> [SearchItem] {
        currentPage += 1
        let urlRequest = URLRequest.Unsplash.search(category: category, word: searchWord!, page: currentPage)

        let searchItems = try await SearchRequest<SearchItem>().sendRequest(with: urlRequest)
        self.searchItems = searchItems

        return searchItems
    }
}


