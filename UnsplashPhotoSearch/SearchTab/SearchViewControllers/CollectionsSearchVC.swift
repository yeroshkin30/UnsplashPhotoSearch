//
//  CollectionsSearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 13.04.2023.
//

import UIKit

class CollectionsSearchVC: BaseSearchVC<Collection> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.collectionsSearchLayout
    }

}

extension CollectionsSearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        searchData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData[section].photoPreviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = searchData[indexPath.section].photoPreviews[indexPath.item]

        cell.configure(with: item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: "header", withReuseIdentifier: "header",
            for: indexPath) as! CollectionsHeaderView
        let item = searchData[indexPath.section]
        header.nameLabel.text = item.title
        header.photoCountLabel.text = "\(item.totalPhotos) photos"

        return header
    }

    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collection = searchData[indexPath.section]
        let collectionVC = CollectionVC(collection)
        show(collectionVC, sender: nil)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item != 0 { return }
        let itemsLeft = searchData.count - indexPath.section

        if itemsLeft == 25 {
            loadNextPage(with: .section)
        }
    }

    func fetchNextPage() {
        let startIndex = searchData.count

        Task {
            do {
                let searchData = try await dataRequestController.loadNextPage()
                self.searchData.append(contentsOf: searchData)
            } catch {
                print(error)
            }
            if searchData.count > startIndex {
                let itemRange = Array(startIndex...self.searchData.count - 1)
                collectionView.insertSections(IndexSet(itemRange))
            }
        }
    }
}
