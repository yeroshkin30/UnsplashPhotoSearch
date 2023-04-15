//
//  PhotosSearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 13.04.2023.
//

import UIKit

class PhotosSearchVC: UIViewController  {

    private let dataRequestController: DataRequestController<Photo>
    var searchData: [Photo] = []

    var searchWord: String = "" {
        didSet {
            if searchWord != oldValue {
                fetchItems()
            }
        }
    }

    private var searchTask: Task<Void, Never>?

    let collectionView: SearchCollectionView = .init(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewCompositionalLayout.photoSearchLayout
    )


    init (controller: DataRequestController<Photo>) {
        self.dataRequestController = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func fetchItems() {
        searchTask?.cancel()
        searchTask = Task {
            do {
                dataRequestController.searchWord = searchWord
                self.searchData = try await dataRequestController.loadNextPage()
            } catch {
                print(error)
            }
            collectionView.reloadData()
            searchTask?.cancel()
        }
    }

    func setup() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.photoSearchLayout
        collectionView.frame = view.bounds
    }

}

extension PhotosSearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = searchData[indexPath.item]
        cell.configure(with: item)

        return cell
    }


    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = searchData[indexPath.item]
        let photoViewController = PhotoVC(photo: photo)
        show(photoViewController, sender: nil)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let itemsLeft = searchData.count - indexPath.item
        if itemsLeft == 25 {

            let startIndex = searchData.count
            let itemRange = Array(startIndex...startIndex + 29)
            let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }

            Task {
                do {
                    let searchData = try await dataRequestController.loadNextPage()
                    self.searchData.append(contentsOf: searchData)
                } catch {
                    print(error)
                }
                collectionView.insertItems(at: insertedIndexRange)
            }
        }
    }
}


