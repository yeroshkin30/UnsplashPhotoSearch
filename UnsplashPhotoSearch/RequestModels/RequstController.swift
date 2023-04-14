//
//  RequstController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit



struct PhotoDataRequest {
    func fetchPhotoData(photoId: String) async throws -> Photo {
        var components = URLComponents(string: "https://api.unsplash.com")!
        components.path = "/photos/\(photoId)"
        let url = URL(string: components.string!)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.photoDataNotFound
        }

        let photoData = try JSONDecoder().decode(Photo.self, from: data)

        return photoData
    }
}

struct FetchPhotos {
    func fetchPhotos(with url: URL, page: Int) async throws -> [Photo] {
       let queryItems = [
            "page": "\(page)",
            "per_page": "30",
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = queryItems
        let url = URL(string: urlComponents.string!)!

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkErrors.photoDataNotFound
        }

        let photoData = try JSONDecoder().decode([Photo].self, from: data)

        return photoData
    }
}



struct UserPhotosRequest {
    func decodeResponse(data: Data) throws -> [Photo] {
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        
        return photos
    }
}
