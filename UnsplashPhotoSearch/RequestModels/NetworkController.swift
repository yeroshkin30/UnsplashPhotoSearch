//
//  SearchRequest.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit


enum NetworkErrors: Error {
    case searchDataNotFound
    case photoDataNotFound
}

struct NetworkService {
    let unsplashURLSession: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        return session
    }()

    func searchRequest<ItemType: Codable>(with urlRequest: URLRequest) async throws -> [ItemType] {
        let (data, response) = try await unsplashURLSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }
        let searchData = try JSONDecoder().decode(SearchResults<ItemType>.self, from: data)

        return searchData.results
    }

    func fetch<ItemType: Codable>(from request: URLRequest) async throws -> ItemType {
        let (data, response) = try await unsplashURLSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }
        let searchResults = try JSONDecoder().decode(ItemType.self, from: data)

        return searchResults
    }
}


struct SearchRequest<ItemType: Codable> {

    private func decodeResponse(data: Data) throws -> [ItemType] {
        let searchResults = try JSONDecoder().decode(SearchResults<ItemType>.self, from: data)
        return searchResults.results
    }

    func sendRequest(with urlRequest: URLRequest) async throws -> [ItemType] {
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }

        let searchData = try decodeResponse(data: data)

        return searchData
    }
}

class UnsplashNetwork<ItemType: Codable> {
    func fetch(from request: URLRequest) async throws -> ItemType {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }

        let searchResults = try JSONDecoder().decode(ItemType.self, from: data)

        return searchResults
    }

}

