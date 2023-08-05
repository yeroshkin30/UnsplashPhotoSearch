//
//  UsersSeachVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 14.04.2023.
//

import UIKit


class UsersSearchVC: UIViewController {

    enum Event {
        case loadNextPage
        case showUser(User)
    }

    var onEvent: ((Event) -> Void)?
    var users: [User] = []

    private let mainView: ChildSearchView = .init(type: .users)
    private var dataSource: UICollectionViewDiffableDataSource<Int, User>!

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

private extension UsersSearchVC {

    func setup() {
        createDataSource()

        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
    }
}

// MARK: - DataSource

private extension UsersSearchVC {
    func createDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Int, User>(
            collectionView: mainView.collectionView,
            cellProvider: { collectionView, indexPath, user in

                let cell: UserInfoCell = collectionView.dequeueCell(for: indexPath)
                cell.configure(with: user)

                return cell
            })

        self.dataSource = dataSource
    }

    func changeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(users, toSection: 0)

        dataSource.apply(snapshot)
    }
}

// MARK: - CollectionView Delegate

extension UsersSearchVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onEvent?(.showUser(users[indexPath.item]))
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard users.count - indexPath.item < 15 else { return }
        onEvent?(.loadNextPage)
    }
}

