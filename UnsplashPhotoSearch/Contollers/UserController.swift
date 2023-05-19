//
//  UserController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 08.04.2023.
//

import UIKit

class UserMediaController<FetchedItem: Codable> {

    private var page: Int = 0
    private var mediaType: String
    private var username: String

    init(_ mediaType: String, username: String) {
        self.mediaType = mediaType
        self.username = username
    }


    //actor
    func loadNextPage() async throws -> [FetchedItem] {
        page += 1
        let urlRequest = URLRequest.Unsplash.userMedia(username: username, mediaType: mediaType, page: page)
        let searchItems = try await UnsplashNetwork<[FetchedItem]>().fetch(from: urlRequest)

        return searchItems
    }
}
