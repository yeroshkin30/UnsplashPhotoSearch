//
//  Photo.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 01.02.2023.
//

import UIKit

extension UIImage {
   static func blurHash(from photo: Photo) -> UIImage? {
        let blurHash = photo.blurHash

        let blurHashSize = CGSize(width: 6, height: 6)

        let image = UIImage(blurHash: blurHash ?? "", size: blurHashSize)

        return image
    }
}

struct Photo: Codable {
    let identifier: UUID = .init()
    let id: String
    let description: String?
    let alternativeDescription: String?
    let blurHash: String?
    let height: Int
    let width: Int
    let photoURL: PhotoURLS
    let user: User?
    var likes: Int?
    var isLiked: Bool
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case alternativeDescription = "alt_description"
        case blurHash = "blur_hash"
        case height
        case width
        case photoURL = "urls"
        case user
        case likes
        case isLiked = "liked_by_user"
        case location
    }
}

extension Photo: Hashable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

struct PhotoURLS: Codable {
    let regular: URL
    let small: URL
    let full: URL
    let thumb: URL
}

struct Location:Codable {
    let name: String?
    let city: String?
    let country: String?
    let position: Coordinate
}
struct Coordinate: Codable {
    let latitude: Double?
    let longitude: Double?
}


