//
//  PhotosSearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 13.04.2023.
//

import UIKit

class PhotosSearchVC: UIViewController {

    enum Event {
        case loadNextPage
        case showPhoto(Photo)
    }

    var onEvent: ((Event) -> Void)?
    var photos: [Photo] = [] {
        didSet {
            changeSnapshot()
        }
    }

    private let mainView: ChildSearchView = .init(type: .photos)
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photo>!

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
        createDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

private extension PhotosSearchVC {
    
    func setup() {
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
    }
}

// MARK: - DataSource

private extension PhotosSearchVC {
    func createDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Int, Photo>(
            collectionView: mainView.collectionView,
            cellProvider: { collectionView, indexPath, photo in

                let cell: PhotoCell = collectionView.dequeueCell(for: indexPath)
                cell.configure(with: photo)

                return cell
            })

        self.dataSource = dataSource
    }

    func changeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos, toSection: 0)

        dataSource.apply(snapshot)
    }
}

// MARK: - CollectionView Delegate

extension PhotosSearchVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onEvent?(.showPhoto(photos[indexPath.item]))
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard photos.count - indexPath.item < 15 else { return }
        onEvent?(.loadNextPage)
    }
}





