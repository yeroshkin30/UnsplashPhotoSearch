//
//  SearchController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 04.08.2023.
//

import UIKit

class DataFetchController {

    static let shared = DataFetchController()
    private init() { }

    private let networkService: NetworkService = .init()

    private var photoPage = 0
    private var collectionPage = 0
    private var userPage = 0

    private (set) var photos: [Photo] = []
    private (set) var collections: [Collection] = []
    private (set) var users: [User] = []

    var searchWord: String? {
        didSet {
            photoPage = 0
            collectionPage = 0
            userPage = 0

            photos = []
            collections = []
            users = []
        }
    }


    func fetchPhotos() async throws -> [Photo] {
        photoPage += 1

        let urlRequest: NetworkRequest<[Photo]> = UnsplashRequests.searchItems(
            type: .photo,
            items: .init(searchWord: searchWord!, page: photoPage, orderedBy: .latest))
        let items = try await networkService.perform(with: urlRequest)
        photos.append(contentsOf: items)

        return photos
    }

    func fetchCollections() async throws -> [Collection] {
        collectionPage += 1

        let urlRequest: NetworkRequest<[Collection]> = UnsplashRequests.searchItems(
            type: .collection,
            items: .init(searchWord: searchWord!, page: collectionPage, orderedBy: .latest))
        let items = try await networkService.perform(with: urlRequest)
        collections.append(contentsOf: items)

        return collections
    }


    func fetchUsers() async throws -> [User] {
        userPage += 1

        let urlRequest: NetworkRequest<[User]> = UnsplashRequests.searchItems(
            type: .user,
            items: .init(searchWord: searchWord!, page: userPage, orderedBy: .latest))
        let items = try await networkService.perform(with: urlRequest)
        users.append(contentsOf: items)

        return users
    }
}


