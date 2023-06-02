//
//  UsersSeachVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 14.04.2023.
//

import UIKit


class UsersSearchVC: BaseSearchVC<User>  {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.usersSearchLayout
    }
}

extension UsersSearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.identifier, for: indexPath) as! UserInfoCell
        let item = searchData[indexPath.item]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = searchData[indexPath.item]
        let userVC = UserVC(user: user)
        show(userVC, sender: nil)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let itemsLeft = searchData.count - indexPath.item
        if itemsLeft == 25, isLoadingFlag == false {
            loadNextPage(with: .item)
        }
    }
}
