//
//  SearchController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

class DataRequestController<Item: Codable> {
    private var searchItems: [Item] = []
    private var page: Int = 0
    private var category: SearchEndpoint
    var searchWord: String? {
        didSet {
            page = 0
        }
    }

    let networkService: NetworkService = .init()
    init(category: SearchEndpoint) {
        self.category = category
    }

    //actor
    func loadNextPage() async throws -> [Item] {
        page += 1
        let urlRequest: NetworkRequest<[Item]> = UnsplashRequests.searchItems(
            type: category,
            items: .init(searchWord: searchWord!, page: page, orderedBy: .latest))

        let items = try await networkService.perform(with: urlRequest)
        self.searchItems = items

        return items
    }
}


