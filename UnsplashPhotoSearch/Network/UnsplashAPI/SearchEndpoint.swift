//
//  SearchEndpoints.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 01.06.2023.
//

import Foundation

struct SearchParam {
    let searchWord: String
    let page: Int
    let itemsPerPage = "30"
    var orderedBy: Order

    enum Order: String {
        case relevant
        case latest
    }
}

enum SearchEndpoint {
    case user
    case collection
    case photo

    var path: String {
        switch self {
        case .user:
            return "/search/users"
        case .collection:
            return "/search/collections"
        case .photo:
            return "/search/photos"
        }
    }

    var httpMethod: String {
        return HTTPMethod.GET.rawValue
    }

    func queryItems(items: SearchParam) -> [URLQueryItem]? {
        [
            Parameters.query: items.searchWord,
            Parameters.page: "\(items.page)",
            Parameters.perPage: items.itemsPerPage,
            Parameters.orderedBy: items.orderedBy.rawValue
        ].map { URLQueryItem(name: $0.key, value: $0.value)}

    }

    enum Parameters {
        static let query = "query"
        static let page = "page"
        static let perPage = "per_page"
        static let orderedBy = "orderedBy"
    }
}
