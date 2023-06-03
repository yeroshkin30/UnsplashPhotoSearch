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
    typealias Parser = (_ data: Data) throws -> Response

    let urlRequest: URLRequest
    let parser: Parser

    init(with request: URLRequest, parser: @escaping Parser) {
        self.urlRequest = request
        self.parser = parser
    }

    init(decodable request: URLRequest) {
        self.init(with: request, parser: { (data: Data) throws -> Response in
            guard let items = try? JSONDecoder().decode(Response.self, from: data) else {
                throw DecodeError.unsuccessfulDecode
            }

            return items
        })
    }
}

extension NetworkRequest {
    func map<Value>(keyPath: KeyPath<Response, Value>) -> NetworkRequest<Value> {
        NetworkRequest<Value>(with: urlRequest) { data in
            try parser(data)[keyPath: keyPath]
        }
    }
}
