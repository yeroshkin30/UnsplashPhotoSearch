//
//  URLRequest extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 16.04.2023.
//

import Foundation

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
