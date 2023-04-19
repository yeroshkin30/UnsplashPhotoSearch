//
//  UserController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 08.04.2023.
//

import UIKit

class UserMediaController<FetchedItem: Codable> {

    private var currentPage: Int = 0
    private var userMediaType: String
    private var username: String

    init(mediatype: String, username: String) {
        self.userMediaType = mediatype
        self.username = username
    }

    private func request(currentPage: Int) -> URLRequest {
        URLRequest(
            username: username,
            mediatype: userMediaType,
            page: currentPage
        )
    }
    //actor
    func loadNextPage() async throws -> [FetchedItem] {
        currentPage += 1
        let urlRequest = request(currentPage: currentPage)
        let searchItems = try await  UserMediaRequest<FetchedItem>().send(with: urlRequest)

        return searchItems
    }
    

//    func fetchUserMedia(category: String, links: UserLinks) async throws {
//        print(category)
//        mediaType = UserMediaType(rawValue: category)!
//        
//        switch mediaType{
//        case .photos:
//            var urlRequest = URLRequest(url: links.photos)
//            urlRequest.setValue("Client-ID ZmifjFVuI-ybPzVC0bjS5fVfOxX8q8KHH813yxMKkhY", forHTTPHeaderField: "Authorization")
//
//            let photos = try await UserPhotosRequest().sendRequest(with: urlRequest)
//            userPhotos = photos
//            
//        case .likes:
//            let urlRequest = URLRequest(url: links.likes)
//            let photos = try await PhotosSearchRequest().sendRequest(with: urlRequest)
//            userLikedPhotos = photos
//        case .collections:
//            return
//        }
//    }
    
    
    
    //Data Source
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        switch mediaType {
//        case .collections:
//            return userCollections.count
//        default:
//            return 1
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch mediaType{
//        case .photos:
//            return userPhotos.count
//        case .likes:
//            return userLikedPhotos.count
//        case .collections:
//            return userCollections[section].photoPreviews.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch mediaType {
//        case .photos:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
//            let item = userPhotos[indexPath.item]
//            cell.configure(with: item)
//
//            return cell
//        case .collections:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
//            let item = userCollections[indexPath.section].photoPreviews[indexPath.item]
//            cell.configure(with: item)
//
//            return cell
//        case .likes:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
//
//            let item = userLikedPhotos[indexPath.item]
//            cell.configure(with: item)
//
//            return cell
//        }
//    }
//
//
//    func createLayout() -> UICollectionViewCompositionalLayout {
//        switch mediaType {
//        case .collections:
//            return UICollectionViewCompositionalLayout.collectionsSearchLayout
//        default:
//            return UICollectionViewCompositionalLayout.photoSearchLayout
//        }
//    }
    
}
