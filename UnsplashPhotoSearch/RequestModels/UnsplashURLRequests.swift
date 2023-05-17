//
//  URLRequest extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 16.04.2023.
//

import Foundation

enum ClientIDs: String {
    case first = "-5QqBcdp57go7e7fuy9Kb5jqmw9V6kY3JfYa7cRO5dU"
    case second = "ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY"
}

extension Array where Element == URLQueryItem {
    static func unsplashQuery(word: String? = nil, page: Int) -> [URLQueryItem] {
        var queryItems = [URLQueryItem(name: "page", value: "\(page)"),
                          URLQueryItem(name: "per_page", value: "30")]

        if let word {
            queryItems.append(URLQueryItem(name: "query", value: word))
        }

        return queryItems
    }
}


extension URLRequest {
    static func unsplash(path: String, queryItems: [URLQueryItem]? = nil) -> URLRequest {
        var components = URLComponents(string: "https://api.unsplash.com")!
        components.path = path
        components.queryItems = queryItems

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.setValue("Client-ID \(ClientIDs.first.rawValue)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}

extension URLRequest {
    enum UnsplashAPI {
        static func search(category: String, word: String,page: Int) -> URLRequest {
            URLRequest.unsplash(path: "/search/\(category)",
                                queryItems: .unsplashQuery(word: word, page: page))
        }

        static func userMedia(username: String, mediaType: String, page: Int) -> URLRequest {
            URLRequest.unsplash(path: "/users/\(username)/\(mediaType)",
                                queryItems: .unsplashQuery(page: page))
        }

        static func collectionsPhoto(id collection: String, page: Int) -> URLRequest {
            URLRequest.unsplash(path: "/collections/\(collection)/photos",
                                queryItems: .unsplashQuery(page: page))
        }

        static func singlePhoto(id photoID: String) -> URLRequest {
            URLRequest.unsplash(path: "/photos/\(photoID)")
        }
    }
}
