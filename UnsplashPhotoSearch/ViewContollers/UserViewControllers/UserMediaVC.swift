//
//  UserMediaVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.04.2023.
//

import UIKit


class UserMediaVC<MediaType: Codable>: UIViewController {
    let collectionView = UICollectionView.initWithCells()
    let userMediaController: UserMediaController<MediaType>

    var mediaData: [MediaType] = []
    var fetchMediaTask: Task<Void, Never>?

    init(controller: UserMediaController<MediaType>) {
        self.userMediaController = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchFirstPage()
    }
    func fetchFirstPage() {
        fetchMediaTask?.cancel()
        fetchMediaTask = Task {
            do {
                self.mediaData = try await userMediaController.loadNextPage()
            } catch {
                print(error)
            }
            collectionView.reloadData()
            fetchMediaTask?.cancel()
        }
    }

    func setup() {
        view.addSubview(collectionView)
    }
}
