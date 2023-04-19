//
//  UsersSearchData.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 30.03.2023.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let location: String?
    let totalPhotos: Int
    let totalLikes: Int
    let totalCollections: Int
    let imageURL: URL
    let links: UserLinks


    enum CustomKeys: String, CodingKey {
        case id
        case username
        case name
        case location
        case totalPhotos = "total_photos"
        case totalLikes = "total_likes"
        case totalCollections = "total_collections"
        case profileImageURL = "profile_image"
        case links
    }

    enum ProfileImageKey: String, CodingKey {
        case large
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CustomKeys.self)
        id = try values.decode(String.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        name = try values.decode(String.self, forKey: .name)
        location = try? values.decode(String.self, forKey: .location)
        totalPhotos = try values.decode(Int.self, forKey: .totalPhotos)
        totalLikes = try values.decode(Int.self, forKey: .totalLikes)
        totalCollections = try values.decode(Int.self, forKey: .totalCollections)
        links = try values.decode(UserLinks.self, forKey: .links)

        let profileImageURLs = try values.nestedContainer(keyedBy: ProfileImageKey.self, forKey: .profileImageURL)
        imageURL = try profileImageURLs.decode(URL.self, forKey: .large)
    }
}

struct UserLinks: Codable {
    let photos: URL
    let likes: URL
    let followers: URL
}
