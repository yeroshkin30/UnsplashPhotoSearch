//
//  APIRequest.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit


enum NetworkErrors: Error {
    case searchDataNotFound
    case photoDataNotFound
}

extension Array where Element == URLQueryItem {
    static func pageQueryItems(searchWord: String, page: Int) -> [URLQueryItem] {
        [
            "page": "\(page)",
            "per_page": "30",
            "query": searchWord
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension URLRequest {
    init(path: String, queryItems: [URLQueryItem]) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"

        components.path = "/search/\(path)"
        components.queryItems = queryItems
        

        let baseURL = URL(string: components.string!)!

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")

        self = urlRequest
    }
}

struct APIRequest<ItemType: Codable> {

    private func decodeResponse(data: Data) throws -> [ItemType] {
        let searchResults = try JSONDecoder().decode(PhotoSearchResults<ItemType>.self, from: data)
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

