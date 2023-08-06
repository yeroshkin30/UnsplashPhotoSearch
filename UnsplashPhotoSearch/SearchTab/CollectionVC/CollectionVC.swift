//
//  CollectionsDetailVC.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 03.04.2023.
//

import UIKit

final class CollectionVC: UIViewController {

    var onShowPhotoEvent: ((Photo) -> Void)?

    // MARK: - Private properties

    private let photosChildVC: PhotosSearchVC = .init()
    private var photos: [Photo] = []
    private let collectionActor: CollectionActor = .init()

    // MARK: - Inits
    
    private let networkService: NetworkService
    private let collection: Collection

    init(_ collection: Collection, network: NetworkService = .init()) {
        self.collection = collection
        self.networkService = network
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private methods

private extension CollectionVC {
    func setup() {
        addChild(controller: photosChildVC, rootView: view)
        photosChildVC.onEvent = { [weak self] event in
            switch event {
            case .loadNextPage:
                self?.getSearchItems()
            case .showPhoto(let photo):
                self?.onShowPhotoEvent?(photo)
            }
        }
        getSearchItems()
    }

    func getSearchItems() {
        guard photosChildVC.photos.count <= collection.totalPhotos else { return }

        Task {
            do {
                photosChildVC.photos = try await collectionActor.fetchPhotos(collection: collection)
            } catch {
                print(error)
            }
        }
    }
}

actor CollectionActor {
    private var page = 0
    private var photos: [Photo] = []
    private let networkService: NetworkService = .init()

    func fetchPhotos(collection: Collection) async throws -> [Photo] {
        page += 1
        let urlRequest = UnsplashRequests.collectionsPhoto(
            id: .collectionPhotos(collection.id),
            items: .init(page: page)
        )
        let photoModels = try await networkService.perform(with: urlRequest)
        photos.append(contentsOf: photoModels)

        return photos
    }
}
