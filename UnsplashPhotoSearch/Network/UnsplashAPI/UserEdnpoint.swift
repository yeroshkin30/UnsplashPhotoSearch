//
//  UserEdnpoint.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 01.06.2023.
//

import Foundation

struct UserParam {
    var page: Int
    let perPage = "30"
}

enum UserEndpoint {
    case user(String)
    case portfolio(String)
    case photos(String)
    case likes(String)
    case collections(String)

    var path: String {
        switch self {
        case .user(let id):
            return "/users/\(id)"

        case .portfolio(let id):
            return "/users/\(id)/portfolio"

        case .photos(let id):
            return "/users/\(id)/photos"

        case .likes(let id):
            return "/users/\(id)/likes"

        case .collections(let id):
            return "/users/\(id)/collections"
        }
    }

    var httpMethod: HTTPMethod { .GET }

    func queryItems(items: UserParam) -> [URLQueryItem]? {
        [
            Parameters.page: "\(items.page)",
            Parameters.per_page: items.perPage,
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
    }

    enum Parameters {
        static let page = "page"                       //    Page number to retrieve. (Optional; default: 1)
        static let per_page = "per_page"                   //    Number of items per page. (Optional; default: 10)
        static let order_by = "order_by"                   //    How to sort the photos. Optional. (Valid values: latest, oldest, popular, views, downloads; default: latest)
    }
}
