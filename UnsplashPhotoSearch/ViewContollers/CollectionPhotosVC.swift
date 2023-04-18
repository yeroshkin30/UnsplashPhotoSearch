//
//  CollectionsDetailVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

class CollectionVC: UIViewController{
    var collectionView: UICollectionView = .init(frame: CGRect(), collectionViewLayout: UICollectionViewCompositionalLayout.photoSearchLayout)
    let photoUrl: URL
    var photosData: [Photo] = []
    var pageNumber = 1

    var photoRequestTask: Task<Void, Never>?

    init (url: URL) {
        self.photoUrl = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageInfoCell.self, forCellWithReuseIdentifier: ImageInfoCell.identifier)

        fetchFirstPage()
    }

    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }

    func fetchFirstPage() {
        photoRequestTask = Task {
            do {
                self.photosData = try await FetchPhotos<Photo>().fetchPhotos(with: photoUrl, page: pageNumber)
            } catch {
                print(error)
            }
            collectionView.reloadData()
            photoRequestTask?.cancel()
        }
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
        let lefted = photosData.count - indexPath.item

        if lefted == 25 {
            pageNumber += 1
            fetchNextPage()
        }
    }

    func fetchNextPage() {
        let startIndex = photosData.count
        Task {
            do {
                let photosData = try await FetchPhotos<Photo>().fetchPhotos(with: photoUrl, page: pageNumber)
                self.photosData.append(contentsOf: photosData)
            } catch {
                print(error)
            }
            if startIndex < photosData.count {
                let itemRange = Array(startIndex...photosData.count - 1)
                let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
                collectionView.insertItems(at: insertedIndexRange)
            }
        }
    }
}














