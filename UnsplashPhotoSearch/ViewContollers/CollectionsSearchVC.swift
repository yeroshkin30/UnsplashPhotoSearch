//
//  CollectionsSearchViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 13.04.2023.
//

import UIKit

class CollectionsSearchViewController: UIViewController  {
    private let collectionView: SearchCollectionView = .init(frame: CGRect.zero,collectionViewLayout: UICollectionViewLayout())

    private let searchController: SearchController<Collection>
    var searchData: [Collection] = []

    var searchWord: String = "" {
        didSet {
            if searchWord != oldValue {
                fetchItems()
            }
        }
    }
    var searchTask: Task<Void, Never>?

    init (controller: SearchController<Collection>) {
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
                searchController.searchWord = searchWord
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
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.collectionsSearchLayout
        collectionView.frame = view.bounds
    }

}

extension CollectionsSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        searchData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData[section].photoPreviews.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageInfoCell.identifier, for: indexPath) as! ImageInfoCell
        let item = searchData[indexPath.section].photoPreviews[indexPath.item]

        cell.configure(with: item)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: "header", withReuseIdentifier: "header",
            for: indexPath) as! CollectionsHeaderView
        let item = searchData[indexPath.section]
        header.nameLabel.text = item.title
        header.photoCountLabel.text = "\(item.totalPhotos) photos"

        return header
    }

    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photosURL = searchData[indexPath.item].photosURL
        let collectionVC = CollectionViewController(url: photosURL)
        show(collectionVC, sender: nil)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item != 0 { return }
        var itemsLeft = searchData.count - indexPath.section

        if itemsLeft == 25 {

            let startIndex = searchData.count
            let itemRange = Array(startIndex...startIndex + 29)

            Task {
                do {
                    let searchData = try await searchController.loadNextPage()
                    self.searchData.append(contentsOf: searchData)
                    collectionView.insertSections(IndexSet(itemRange))
                } catch {
                    print(error)
                }
            }
        }
    }
}
