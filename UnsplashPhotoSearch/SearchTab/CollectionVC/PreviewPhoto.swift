//
//  PreviewPhoto.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 06.08.2023.
//

import Foundation

import Foundation

struct PreviewPhoto: Codable {
    let identifier: UUID = .init()
    let id: String
    let blurHash: String?
    let photoURL: PhotoURLS

    enum CodingKeys: String, CodingKey {
        case id
        case blurHash = "blur_hash"
        case photoURL = "urls"
    }
}

extension PreviewPhoto: Hashable {
    static func == (lhs: PreviewPhoto, rhs: PreviewPhoto) -> Bool {
        lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
