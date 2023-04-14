//
//  UsersSeachVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 14.04.2023.
//

import UIKit


class UsersSearchViewController: UIViewController  {

    private let searchController: SearchController<User>
    var searchData: [User] = []
    private var searchTask: Task<Void, Never>?

    let collectionView: SearchCollectionView = .init(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewCompositionalLayout.photoSearchLayout
    )


    init (controller: SearchController<User>) {
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
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.usersSearchLayout
        collectionView.frame = view.bounds
    }

}

extension UsersSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.identifier, for: indexPath) as! UserInfoCell
        let item = searchData[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}
