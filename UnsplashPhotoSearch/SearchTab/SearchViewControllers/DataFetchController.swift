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

    private var photoPage = 0
    private var collectionPage = 0
    private var userPage = 0


    var photos: [Photo] = []
    var collections: [Collection] = []
    var users: [User] = []

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

    let networkService: NetworkService = .init()

    func fetchPhotos() async -> [Photo] {
        photoPage += 1

        let urlRequest: NetworkRequest<[Photo]> = UnsplashRequests.searchItems(
            type: .photo,
            items: .init(searchWord: searchWord!, page: photoPage, orderedBy: .latest))
        do {
            let items = try await networkService.perform(with: urlRequest)
            photos.append(contentsOf: items)
        } catch {
            print(error)
        }

        return photos
    }

    func fetchCollections() async -> [Collection] {
        collectionPage += 1

        let urlRequest: NetworkRequest<[Collection]> = UnsplashRequests.searchItems(
            type: .collection,
            items: .init(searchWord: searchWord!, page: collectionPage, orderedBy: .latest))
        do {
            let items = try await networkService.perform(with: urlRequest)
            collections.append(contentsOf: items)
        } catch {
            print(error)
        }

        return collections
    }


    func fetchUsers() async -> [User] {
        userPage += 1

        let urlRequest: NetworkRequest<[User]> = UnsplashRequests.searchItems(
            type: .user,
            items: .init(searchWord: searchWord!, page: userPage, orderedBy: .latest))
        do {
            let items = try await networkService.perform(with: urlRequest)
            users.append(contentsOf: items)
        } catch {
            print(error)
        }

        return users
    }
}


