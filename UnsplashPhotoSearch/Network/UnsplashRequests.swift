//
//  URLRequest extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 16.04.2023.
//

import Foundation

enum UnsplashRequests {
    static func searchItems<Response>(type: SearchEndpoint, items: SearchParam) -> NetworkRequest<Response> {
        NetworkRequest(with: URLRequest(
            path: type.path,
            queryItems: type.queryItems(items: items))
        )
    }
    
    static func userMedia<Response>(type: UserEndpoint, items: UserParam) -> NetworkRequest<Response> {
        NetworkRequest(with: URLRequest(
            path: type.path,
            queryItems: type.queryItems(items: items),
            method: type.httpMethod)
        )
    }
    
    static func collectionsPhoto(id collection: CollectionEndpoint, items: CollectionParam) -> NetworkRequest<[Photo]> {
        NetworkRequest(with: URLRequest(
            path: collection.path,
            queryItems: collection.queryItems(items: items),
            method: collection.httpMethod)
        )
    }
    
    static func singlePhoto(id photo: PhotoEndpoint ) -> NetworkRequest<Photo> {
        NetworkRequest(with: URLRequest(path: photo.path))
    }
    
    // MARK: - AuthorizationRequests
    static func userToken(with code: String) -> NetworkRequest<Token> {
        let queryItems = [
            UnsplashParameterName.Authentication.clientID:      UnsplashAPI.clientID,
            UnsplashParameterName.Authentication.clientSecret:  UnsplashAPI.clientSecret,
            UnsplashParameterName.Authentication.redirectURI:   UnsplashAPI.callbackUrlScheme,
            UnsplashParameterName.Authentication.code:          code,
            UnsplashParameterName.Authentication.grantType:     UnsplashParameterName.Authentication.authorizationCode
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        var components = URLComponents(string: "https://unsplash.com")!
        components.path = "/oauth/token"
        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethod.POST.rawValue

        return NetworkRequest(with: request)
    }

    static func userProfile() -> NetworkRequest<User> {
        NetworkRequest(with: URLRequest(path: "/me"))
    }

    static func editUserProfile(with editableData: EditableUserData) -> NetworkRequest<User> {
        let parameters = [
            UnsplashParameterName.User.userName: editableData.userName,
            UnsplashParameterName.User.firstName: editableData.firstName,
            UnsplashParameterName.User.lastName: editableData.lastName,
            UnsplashParameterName.User.location: editableData.location,
            UnsplashParameterName.User.biography: editableData.biography
        ].compactMapValues { $0 }
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        return NetworkRequest(with: URLRequest(
            path: "/me",
            queryItems: queryItems,
            method: .PUT))
    }
}




