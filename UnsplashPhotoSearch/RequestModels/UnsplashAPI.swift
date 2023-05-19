//
//  Unsplash.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import Foundation

enum UnsplashAPI {

    static let accessTokenKey = "accessTokenKey"
    static let callbackUrlScheme = "unsplashPhoto"
    static let clientID = "ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY"
    static let clientSecret = "PuzzV74r4Uk5wgNkmmFu27i56VAjOCTaDAGjocNSGvc"

    static let logOutURL = URL(string: "https://unsplash.com/logout")!

    static var logInURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/authorize"
        urlComponents.queryItems = authorizationQueryParameters
        return urlComponents.url!
    }

    private static var authorizationQueryParameters: [URLQueryItem] {
        let scopeValues: [UnsplashPermissionScope] = [
            .readPublicData, .readUserData, .readUserPhotos, .readUserCollections,
            .writeUserData, .writeUserLikes
        ]

        let responseType = "code"
        let scope = scopeValues.map { $0.rawValue }.joined(separator: "+")

        return [
            URLQueryItem(name: UnsplashParameterName.Authentication.clientID, value: UnsplashAPI.clientID),
            URLQueryItem(name: UnsplashParameterName.Authentication.redirectURI, value: UnsplashAPI.callbackUrlScheme),
            URLQueryItem(name: UnsplashParameterName.Authentication.responseType, value: responseType),
            URLQueryItem(name: UnsplashParameterName.Authentication.scope, value: scope)
        ]
    }
}

enum UnsplashParameterName {
    enum Authentication {
        static let authorizationCode = "authorization_code"
        static let accessToken = "access_token"
        static let clientID = "client_id"
        static let clientSecret = "client_secret"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let code = "code"
        static let scope = "scope"
        static let grantType = "grant_type"
    }
}

enum UnsplashPermissionScope: String {
    case readPublicData = "public"                    // Default. Read public data.
    case readUserData = "read_user"                    // Access user’s private data.
    case writeUserData = "write_user"                // Update the user’s profile.
    case readUserPhotos = "read_photos"                // Read private data from the user’s photos.
    case writeUserPhotos = "write_photos"            // Update photos on the user’s behalf.
    case writeUserLikes = "write_likes"                // Like or unlike a photo on the user’s behalf.
    case writeUserSubscriptions = "write_followers"    // Follow or unfollow a user on the user’s behalf.
    case readUserCollections = "read_collections"     // View a user’s private collections.
    case writeUserCollections = "write_collections"    // Create and update a user’s collections.
}
