//
//  PhotosSearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 13.04.2023.
//

import UIKit

class PhotosSearchViewController: UIViewController  {

    private let searchController: SearchController<Photo>
    var searchData: [Photo] = []
    private var searchTask: Task<Void, Never>?

    let collectionView: SearchCollectionView = .init(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewCompositionalLayout.photoSearchLayout
    )


    init (controller: SearchController<Photo>) {
        self.searchController = controller
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
                self.searchData = try await searchController.loadNextPage()
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

extension PhotosSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
print(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = searchData[indexPath.item]
        cell.configure(with: item)
        return cell
    }


    //DELEGATE
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let photo = photoSearchData[indexPath.item]
//        onEvent?(.photoSelected(photo))
//    }


//    func collectionView(
//        _ collectionView: UICollectionView,
//        willDisplay cell: UICollectionViewCell,
//        forItemAt indexPath: IndexPath
//    ) {
//        var startIndex = photoSearchData.count
//        var lefted = photoSearchData.count - indexPath.item
//
//        let itemRange = Array(startIndex...startIndex + 29)
//
//        if lefted == 25 {
//
//            Task {
//                do {
//                    //                    try await loadNextPage()
//
//                    self.onEvent?(.itemsInserted(itemRange))
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
}


