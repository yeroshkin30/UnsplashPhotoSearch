//
//  CollectionsSearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 13.04.2023.
//

import UIKit

class CollectionsSearchVC: UIViewController {

    enum Event {
        case loadNextPage
        case showCollection(Collection)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let mainView: ChildSearchView = .init(type: .collections)
    private var dataSource: UICollectionViewDiffableDataSource<Collection, PreviewPhoto>!
    var collections: [Collection] = []

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func loadView() {
        super.loadView()
        view = mainView
    }
}

// MARK: - Private methods

private extension CollectionsSearchVC {
    func setup() {
        createDataSource()
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
    }
}

// MARK: - DataSource

private extension CollectionsSearchVC {
    func createDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Collection, PreviewPhoto>(
            collectionView: mainView.collectionView,
            cellProvider: { collectionView, indexPath, previewPhoto in
                let cell: PhotoCell = collectionView.dequeueCell(for: indexPath)
                cell.configure(with: previewPhoto)

                return cell
            })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header: CollectionsHeaderView = collectionView.dequeueHeader(for: indexPath)
            let collection = self.collections[indexPath.section]
            header.configure(
                name: collection.title,
                number: "\(collection.totalPhotos) photos"
            )

            return header
        }

        self.dataSource = dataSource
    }

    func changeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Collection, PreviewPhoto>()
        snapshot.appendSections(collections)
        collections.forEach {
            snapshot.appendItems($0.photoPreviews, toSection: $0)
        }

        dataSource.apply(snapshot)
    }
}

// MARK: - CollectionView Delegate

extension CollectionsSearchVC:  UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onEvent?(.showCollection(collections[indexPath.item]))
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item != 0 { return }

        guard collections.count - indexPath.section < 15 else { return }
        onEvent?(.loadNextPage)
    }
}
