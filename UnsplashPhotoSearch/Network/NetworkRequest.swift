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
