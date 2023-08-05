//
//  ChildSearchView.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 04.08.2023.
//

import UIKit

final class ChildSearchView: UIView {

    // MARK: - Private properties

    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    // MARK: - Inits

    init(type: ViewType) {
        super.init(frame: .zero)
        setupCollectionView(with: type)
        collectionView.layout(in: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChildSearchView {

    // MARK: - Private methods

    func setupCollectionView(with type: ViewType) {
        switch type {
        case .photos:
            collectionView.register(cell: PhotoCell.self )
            collectionView.collectionViewLayout = .photoSearchLayout

        case .collections:
            collectionView.register(cell: PhotoCell.self )
            collectionView.register(header: CollectionsHeaderView.self)
            collectionView.collectionViewLayout = .collectionsSearchLayout

        case .users:
            collectionView.register(cell: UserInfoCell.self)
            collectionView.collectionViewLayout = .usersSearchLayout

        }
    }
}

extension ChildSearchView {
    enum ViewType {
        case photos
        case collections
        case users
    }
}
