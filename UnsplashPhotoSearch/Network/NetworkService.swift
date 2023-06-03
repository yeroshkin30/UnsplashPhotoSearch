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
     private let unsplashURLSession: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        return session
    }()

    func perform<Response: Codable>(with request: NetworkRequest<Response>) async throws -> Response {
        let (data, response) = try await unsplashURLSession.data(for: request.urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.searchDataNotFound
        }
        let searchResults = try request.parser(data)

        return searchResults
    }
}

