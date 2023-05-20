//
//  URLRequest extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 16.04.2023.
//

import Foundation

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
        urlRequest.allHTTPHeaderFields = ["Authorization": "Client-ID \(UnsplashAPI.clientID)"]
        if let token = UserDefaults.standard.string(forKey: UnsplashAPI.accessTokenKey) {
            print("asdf")
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
        }

        return urlRequest
    }
}

extension URLRequest {
    enum Unsplash {
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

        static func userToken(with code: String) -> URLRequest {
            let itemsDictionary = [
                UnsplashParameterName.Authentication.clientID:      UnsplashAPI.clientID,
                UnsplashParameterName.Authentication.clientSecret:  UnsplashAPI.clientSecret,
                UnsplashParameterName.Authentication.redirectURI:   UnsplashAPI.callbackUrlScheme,
                UnsplashParameterName.Authentication.code:          code,
                UnsplashParameterName.Authentication.grantType:     UnsplashParameterName.Authentication.authorizationCode
            ]

            var components = URLComponents(string: "https://unsplash.com")!
            components.path = "/oauth/token"
            components.queryItems = itemsDictionary.map { URLQueryItem(name: $0.key, value: $0.value) }

            var request = URLRequest(url: components.url!)
            request.httpMethod = "POST"

            return request
        }
    }
}
