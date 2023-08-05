//
//  CollectionsDetailVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

class CollectionVC: UIViewController {
    var collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewCompositionalLayout.photoSearchLayout)
    let collection: Collection
    var photos: [Photo] = []
    var page = 1
    let networkService: NetworkService = .init()
    var photoRequestTask: Task<Void, Never>?

    init (_ collection: Collection) {
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        fetchFirstPage()
    }

    func fetchFirstPage() {
        photoRequestTask = Task {
            do {
                let urlRequest: NetworkRequest<[Photo]> = UnsplashRequests.collectionsPhoto(
                    id: .collectionPhotos(collection.id),
                    items: .init(page: page)
                )
                self.photos = try await networkService.perform(with: urlRequest)
            } catch {
                print(error)
            }
            collectionView.reloadData()
            photoRequestTask?.cancel()
        }
    }

    private func setup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.frame = view.bounds
    }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        let item = photos[indexPath.item]
        cell.configure(with: item)

        return cell
    }

    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let photoDetailVC = PhotoVC(photo: photo)
        
        self.show(photoDetailVC, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemsLeft = photos.count - indexPath.item

        if itemsLeft == 25 {
            page += 1
            fetchNextPage()
        }
    }

    func fetchNextPage() {
        guard collection.totalPhotos > photos.count else { return }

        let startIndex = photos.count

        Task {
            do {
                let urlRequest: NetworkRequest<[Photo]> = UnsplashRequests.collectionsPhoto(
                    id: .collectionPhotos(collection.id),
                    items: .init(page: page)
                )
                let photos = try await networkService.perform(with: urlRequest)
                self.photos.append(contentsOf: photos)
            } catch {
                print(error)
            }
            let itemRange = Array(startIndex...photos.count - 1)
            let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: insertedIndexRange)
        }
    }
}














