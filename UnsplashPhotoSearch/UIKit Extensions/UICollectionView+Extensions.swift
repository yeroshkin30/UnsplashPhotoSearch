//
//  SearchView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 05.04.2023.
//

import UIKit

extension UICollectionView {
    static func initWithCells() -> UICollectionView {
        let cv = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        cv.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.identifier)
        cv.register(CollectionsHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        cv.backgroundColor = .white

        return cv
    }
}

extension UIView {
    // Return class name for use it in Register cells
    static var identifier: String {
        return String(describing: self)
    }
}

// CollectionView Extensions
extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    func register<T: UICollectionReusableView>(header: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier
        )
    }

    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.identifier
        )
    }

    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: T.identifier,
                                                for: indexPath) as! T
    }
}

// MARK: - Layout

extension UICollectionViewLayout {
    static var photoSearchLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(3)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                        leading: 0,
                                                        bottom: 0,
                                                        trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }

    static var collectionsSearchLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/4),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 4
        )
        group.interItemSpacing = .fixed(3)

        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 7, bottom: 10, trailing: 7)
        section.boundarySupplementaryItems = [sectionHeader]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "background")]
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SectionBackgroundColor.self, forDecorationViewOfKind: "background")

        return layout
    }

    static var usersSearchLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                        leading: 5,
                                                        bottom: 5,
                                                        trailing: 5)
        section.interGroupSpacing = 5

        return UICollectionViewCompositionalLayout(section: section)
    }
}
