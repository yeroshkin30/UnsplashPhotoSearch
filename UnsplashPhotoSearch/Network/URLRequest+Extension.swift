//
//  URLRequest+Extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 02.06.2023.
//

import Foundation

extension URLRequest {
    init (path: String,
          queryItems: [URLQueryItem]? = nil,
          method: HTTPMethod = .GET) {

        var components = URLComponents(string: "https://api.unsplash.com")!
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else { fatalError("Invalid URL") }

        self.init(url: url)
        httpMethod = method.rawValue
        allHTTPHeaderFields = ["Authorization": "Client-ID \(UnsplashAPI.clientID)"]
        if let token = UserDefaults.standard.string(forKey: UnsplashAPI.accessTokenKey) {
            allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
        }
    }
}
