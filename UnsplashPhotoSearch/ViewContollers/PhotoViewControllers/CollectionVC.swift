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
    var collectionPhotos: [Photo] = []
    var page = 1
    let requestController = UnsplashNetwork<[Photo]>()
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
                let request = URLRequest.Unsplash.collectionsPhoto(id: collection.id, page: page)
                self.collectionPhotos = try await requestController.fetch(from: request)
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
        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.identifier)
        collectionView.frame = view.bounds
    }
}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = collectionPhotos[indexPath.item]
        cell.configure(with: item)

        return cell
    }

    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = collectionPhotos[indexPath.item]
        let photoDetailVC = PhotoVC(photo: photo)
        
        self.show(photoDetailVC, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemsLeft = collectionPhotos.count - indexPath.item

        if itemsLeft == 25 {
            page += 1
            fetchNextPage()
        }
    }

    func fetchNextPage() {
        guard collection.totalPhotos > collectionPhotos.count else { return }

        let startIndex = collectionPhotos.count

        Task {
            do {
                let request = URLRequest.Unsplash.collectionsPhoto(id: collection.id, page: page)
                let photos = try await requestController.fetch(from: request)
                self.collectionPhotos.append(contentsOf: photos)
            } catch {
                print(error)
            }
            let itemRange = Array(startIndex...collectionPhotos.count - 1)
            let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: insertedIndexRange)
        }
    }
}














