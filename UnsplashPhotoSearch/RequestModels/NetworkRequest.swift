//
//  NetworkRequest.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 01.06.2023.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum DecodeError: Error {
    case unsuccessfulDecode
}

struct NetworkRequest<Response: Codable> {
    let urlRequest: URLRequest

    init(with request: URLRequest) {
        self.urlRequest = request
    }

    var decoder = { (data: Data) throws -> Response in
        guard let items = try? JSONDecoder().decode(Response.self, from: data) else {
            throw DecodeError.unsuccessfulDecode
        }

        return items
    }
}

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
