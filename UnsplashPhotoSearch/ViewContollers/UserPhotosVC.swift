//
//  UserPhotosVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.04.2023.
//

import UIKit

class UserPhotosVC: UserMediaVC<Photo> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.photoSearchLayout
    }
}

extension UserPhotosVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = mediaData[indexPath.item]
        cell.configure(with: item)

        return cell
    }


    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = mediaData[indexPath.item]
        let photoViewController = PhotoVC(photo: photo)
        show(photoViewController, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemsLeft = mediaData.count - indexPath.item
        if itemsLeft == 25 {
            fetchNextPage()
        }
    }

    func fetchNextPage() {
        let startIndex = mediaData.count

        Task {
            do {
                let mediaData = try await mediaRequestController.loadNextPage()
                self.mediaData.append(contentsOf: mediaData)
            } catch {
                print(error)
            }
            let itemRange = Array(startIndex...self.mediaData.count - 1)
            let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: insertedIndexRange)
        }
    }
}
