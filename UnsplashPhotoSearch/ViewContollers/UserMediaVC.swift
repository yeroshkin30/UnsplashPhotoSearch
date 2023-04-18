//
//  UserMediaVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.04.2023.
//

import UIKit


class UserMediaVC<MediaType: Codable>: UIViewController {
    let collectionView: SearchCollectionView = .init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()
    )
    let mediaRequestController: UserController<MediaType>

    var mediaData: [MediaType] = []
    var fetchMediaTask: Task<Void, Never>?

    init(controller: UserController<MediaType>) {
        self.mediaRequestController = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func fetchFirstPage() {
        fetchMediaTask?.cancel()
        fetchMediaTask = Task {
            do {
                self.mediaData = try await mediaRequestController.loadNextPage()
            } catch {
                print(error)
            }
            collectionView.reloadData()
            fetchMediaTask?.cancel()
        }
    }

    func setup() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
}
