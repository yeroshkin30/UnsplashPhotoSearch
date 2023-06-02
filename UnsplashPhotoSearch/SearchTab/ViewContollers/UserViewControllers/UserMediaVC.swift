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
    var isLoadingFlag = false
    
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
//        fetchFirstPage()
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

    func loadNextPage(with index: IndexType) {
        let startIndex = mediaData.count

        isLoadingFlag = true

        Task {
            do {
                let mediaData = try await userMediaController.loadNextPage()
                guard mediaData.count > 0 else { return }
                self.mediaData.append(contentsOf: mediaData)
            } catch {
                print(error)
            }
            if mediaData.count > startIndex {
                let itemRange = Array(startIndex...self.mediaData.count - 1)

                switch index {
                case .item:
                    let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
                    collectionView.insertItems(at: insertedIndexRange)
                case.section:
                    let itemRange = Array(startIndex...self.mediaData.count - 1)
                    collectionView.insertSections(IndexSet(itemRange))
                }
            }
            isLoadingFlag = false
        }
    }

    enum IndexType {
        case section
        case item
    }
}
