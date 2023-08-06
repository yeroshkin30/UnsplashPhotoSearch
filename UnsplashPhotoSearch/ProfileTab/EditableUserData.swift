//
//  EditableUserData.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 27.05.2023.
//

import Foundation

struct EditableUserData {
    var userName: String?
    var firstName: String?
    var lastName: String?
    var location: String?
    var biography: String?

    func isDataValid() -> Bool {
        return true
    }
}
