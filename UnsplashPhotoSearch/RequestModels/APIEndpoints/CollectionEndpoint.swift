//
//  APIEndpoints.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 01.06.2023.
//

import Foundation

struct CollectionParam {
    let page: Int
    let perPage = "30"
}

enum CollectionEndpoint {
    case id(String)
    case collectionPhotos(String)
    case createCollection
    case updateCollection(String)
    case deleteCollection(String)
    case addPhoto(String)
    case removePhoto(String)

    var path: String {
        switch self {
        case .id(let id):
            return "/collections/\(id)"

        case .collectionPhotos(let id):
            return "/collections/\(id)/photos"

        case .createCollection:
            return "/collections"

        case .updateCollection(let id):
            return "/collections/\(id)"

        case .deleteCollection(let id):
            return "collection/\(id)"

        case .addPhoto(let id):
            return "/collections/\(id)/add"

        case .removePhoto(let id):
            return "/collections/\(id)/remove"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .id(_), .collectionPhotos(_):
            return .GET
        case .createCollection, .addPhoto(_):
            return .POST
        case .updateCollection(_):
            return .PUT
        case .deleteCollection(_), .removePhoto(_):
            return .DELETE
        }
    }

    func queryItems(items: CollectionParam) -> [URLQueryItem]? {
        [
            Parameters.page: "\(items.page)",
            Parameters.perPage: items.perPage,
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
    }

    enum Parameters {
        static let page = "page"
        static let perPage = "per_page"
        
        //update and create
        static let title = "title"                      //    The title of the collection. (Required.)
        static let description = "description"                //    The collection’s description. (Optional.)
        static let private1 = "private1"                   //    Whether to make this collection private. (Optional; default false).
        static let photoId = "photo_id"
    }
}



