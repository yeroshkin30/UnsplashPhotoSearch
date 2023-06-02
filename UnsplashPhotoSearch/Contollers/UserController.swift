//
//  UserController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 08.04.2023.
//

import UIKit

class UserMediaController<Item: Codable> {
    private var page: Int = 0
    private var mediaType: UserEndpoint

    let networkService: NetworkService = .init()

    init(_ mediaType: UserEndpoint) {
        self.mediaType = mediaType
    }


    //actor
    func loadNextPage() async throws -> [Item] {
        page += 1
        let urlRequest: NetworkRequest<[Item]> = UnsplashRequests.userMedia(
            type: mediaType,
            items: .init(page: page)
        )
        let items = try await networkService.perform(with: urlRequest)

        return items
    }
}
