//
//  UserFetchController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 06.08.2023.
//


import UIKit

class UserFetchController {

    static let shared = UserFetchController()
    private init() { }

    private let networkService: NetworkService = .init()

    private var page = 0
    private var likedPhotoPage = 0
    private var collectionPage = 0

    private (set) var photos: [Photo] = []
    private (set) var likedPhotos: [Photo] = []
    private (set) var collections: [Collection] = []

    let userId = "id"
    var searchWord: String? {
        didSet {
            page = 0
            collectionPage = 0
            likedPhotoPage = 0
        }
    }

    func fetchItems<ItemType: Codable>(type: MediaType) async throws -> [ItemType] {
        page += 1

        let urlRequest: NetworkRequest<[ItemType]> = UnsplashRequests.usersMedia(
            userId: userId,
            type: type.rawValue,
            page: page
        )
        let items = try await networkService.perform(with: urlRequest)
        switch type {
        case .photos:
            photos.append(contentsOf: items as! [Photo])
        case .likes:
            likedPhotos.append(contentsOf: items as! [Photo])
        case .collections:
            collections.append(contentsOf: items as! [Collection])
        }

        return items
    }

    enum MediaType: String {
        case photos
        case likes
        case collections
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
        likedPhotoPage += 1

        let urlRequest: NetworkRequest<[Photo]> = UnsplashRequests.searchItems(
            type: .user,
            items: .init(searchWord: searchWord!, page: likedPhotoPage, orderedBy: .latest))
        let items = try await networkService.perform(with: urlRequest)
        likedPhotos.append(contentsOf: items)

        return likedPhotos
    }
}


