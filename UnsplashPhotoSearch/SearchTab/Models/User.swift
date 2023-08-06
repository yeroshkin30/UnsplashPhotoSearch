//
//  UsersSearchData.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 30.03.2023.
//

import Foundation

struct User: Codable {
    let identifier: UUID = .init()
    let id: String
    let username: String
    let name: String
    let firstName: String
    let lastName: String?
    let biography: String?
    let location: String?
    let totalPhotos: Int
    let totalLikes: Int
    let totalCollections: Int
    let imageURL: URL


    enum CustomKeys: String, CodingKey {
        case id
        case username
        case name
        case location
        case firstName = "first_name"
        case lastName = "last_name"
        case biography = "bio"
        case totalPhotos = "total_photos"
        case totalLikes = "total_likes"
        case totalCollections = "total_collections"
        case profileImageURL = "profile_image"
    }

    enum ProfileImageKey: String, CodingKey {
        case large
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CustomKeys.self)
        id = try values.decode(String.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        name = try values.decode(String.self, forKey: .name)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try? values.decode(String.self, forKey: .lastName)
        biography = try? values.decode(String.self, forKey: .biography)
        location = try? values.decode(String.self, forKey: .location)
        totalPhotos = try values.decode(Int.self, forKey: .totalPhotos)
        totalLikes = try values.decode(Int.self, forKey: .totalLikes)
        totalCollections = try values.decode(Int.self, forKey: .totalCollections)

        let profileImageURLs = try values.nestedContainer(keyedBy: ProfileImageKey.self, forKey: .profileImageURL)
        imageURL = try profileImageURLs.decode(URL.self, forKey: .large)
    }
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
