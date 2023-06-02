//
//  UserCollecitonsVC.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 19.04.2023.
//

import UIKit

class UserCollectionsVC: UserMediaVC<Collection> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.collectionsSearchLayout
    }
}

extension UserCollectionsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        mediaData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaData[section].photoPreviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = mediaData[indexPath.section].photoPreviews[indexPath.item]

        cell.configure(with: item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: "header", withReuseIdentifier: "header",
            for: indexPath) as! CollectionsHeaderView
        let item = mediaData[indexPath.section]
        header.nameLabel.text = item.title
        header.photoCountLabel.text = "\(item.totalPhotos) photos"

        return header
    }

    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = mediaData[indexPath.section]
        let collectionVC = CollectionVC(collection)
        show(collectionVC, sender: nil)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item != 0 { return }
        let itemsLeft = mediaData.count - indexPath.section

        if itemsLeft == 25 {
            loadNextPage(with: .section)
        }
    }


}
