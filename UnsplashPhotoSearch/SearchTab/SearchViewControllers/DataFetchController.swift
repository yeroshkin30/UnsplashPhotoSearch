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

    private var page: Int = 0

    var photos: [Photo] = []
    var collections: [Collection] = []
    var users: [User] = []

    var searchWord: String? {
        didSet {
            page = 0
        }
    }

    let networkService: NetworkService = .init()

    func fetchPhotos() async -> [Photo] {
        page += 1

        let urlRequest: NetworkRequest<[Photo]> = UnsplashRequests.searchItems(
            type: .photo,
            items: .init(searchWord: searchWord!, page: page, orderedBy: .latest))
        do {
            let items = try await networkService.perform(with: urlRequest)
            photos.append(contentsOf: items)
        } catch {
            print(error)
        }

        return photos
    }

    func fetchCollections() async -> [Collection] {
        page += 1

        let urlRequest: NetworkRequest<[Collection]> = UnsplashRequests.searchItems(
            type: .collection,
            items: .init(searchWord: searchWord!, page: page, orderedBy: .latest))
        do {
            let items = try await networkService.perform(with: urlRequest)
            collections.append(contentsOf: items)
        } catch {
            print(error)
        }

        return collections
    }


    func fetchUsers() async -> [User] {
        page += 1

        let urlRequest: NetworkRequest<[User]> = UnsplashRequests.searchItems(
            type: .user,
            items: .init(searchWord: searchWord!, page: page, orderedBy: .latest))
        do {
            let items = try await networkService.perform(with: urlRequest)
            users.append(contentsOf: items)
        } catch {
            print(error)
        }

        return users
    }
}


