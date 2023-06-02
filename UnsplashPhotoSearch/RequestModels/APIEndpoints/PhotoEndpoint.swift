//
//  PhotoEndpoint.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 01.06.2023.
//

import Foundation

enum PhotoEndpoint {
    case photo(String)
    case download(String)
    case like(Photo)
    case unlike(Photo)

    var path: String {
        switch self {
        case .photo(let id):
            return "/photos/\(id)"

        case .download(let id):
            return "/photos/\(id)/download"

        case .like(let id):
            return "/photos/\(id)/like"

        case .unlike(let id):
            return "/photos/\(id)/unlike"
        }
    }

    var httpMethod: String {
        switch self {
        case .photo(_), .download(_):
            return HTTPMethod.GET.rawValue

        case .like(_):
            return HTTPMethod.POST.rawValue

        case .unlike(_):
            return HTTPMethod.DELETE.rawValue
        }
    }
}
