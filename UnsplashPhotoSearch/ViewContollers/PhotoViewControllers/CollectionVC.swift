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
    var photosData: [Photo] = []
    var pageNumber = 1

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
                self.photosData = try await FetchPhotos<Photo>().fetchPhotos(with: collection.photosURL, page: pageNumber)
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
        return photosData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = photosData[indexPath.item]
        cell.configure(with: item)

        return cell
    }

    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photosData[indexPath.item]
        let photoDetailVC = PhotoVC(photo: photo)
        
        self.show(photoDetailVC, sender: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemsLeft = photosData.count - indexPath.item

        if itemsLeft == 25 {
            pageNumber += 1
            fetchNextPage()
        }
    }

    func fetchNextPage() {
        guard collection.totalPhotos > photosData.count else { return }

        let startIndex = photosData.count

        Task {
            do {
                let photosData = try await FetchPhotos<Photo>().fetchPhotos(with: collection.photosURL, page: pageNumber)
                self.photosData.append(contentsOf: photosData)
            } catch {
                print(error)
            }
            let itemRange = Array(startIndex...photosData.count - 1)
            let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: insertedIndexRange)
        }
    }
}














