//
//  UserController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 08.04.2023.
//

import UIKit

class UserMediaController<FetchedItem: Codable> {

    private var currentPage: Int = 0
    private var mediaType: String
    private var username: String

    init(_ mediaType: String, username: String) {
        self.mediaType = mediaType
        self.username = username
    }

    private func request(currentPage: Int) -> URLRequest {
        URLRequest(
            username: username,
            mediatype: mediaType,
            page: currentPage
        )
    }
    //actor
    func loadNextPage() async throws -> [FetchedItem] {
        currentPage += 1
        let urlRequest = request(currentPage: currentPage)
        let searchItems = try await  UserMediaRequest<FetchedItem>().send(with: urlRequest)

        return searchItems
    }
}
