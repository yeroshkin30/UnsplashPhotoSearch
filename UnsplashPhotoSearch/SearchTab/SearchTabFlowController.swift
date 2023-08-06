//
//  SearchTabFlowController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 04.08.2023.
//

import UIKit

class SearchTabFlowController: UINavigationController {

    private let dataFetchController: DataFetchController

    // MARK: - Inits

    init(controller: DataFetchController = .shared) {
        self.dataFetchController = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        setupMainSearchVC()
    }
}

private extension SearchTabFlowController {

    // MARK: - Private methods

    func setupMainSearchVC() {
        let controller = MainSearchVC()
        controller.onEvent = { [weak self] event in
            guard let self else { return }

            switch event {
            case .showPhoto(let photo):
                showPhotoVC(with: photo)

            case .showCollection(let collection):
                showCollectionVC(with: collection)

            case .showUser(let user):
                showUserVC(with: user)
            }
        }

        viewControllers = [controller]
    }

    func showPhotoVC(with photo: Photo) {
        let controller = PhotoVC(photo: photo)
        controller.onEvent = { [weak self] event in
            self?.handlePhotoVCEvent(with: event)
        }
        
        show(controller, sender: self)
    }

    func showCollectionVC(with collection: Collection) {
        let controller = CollectionVC(collection)
        controller.onShowPhotoEvent = { [weak self] photo in
            self?.showPhotoVC(with: photo)
        }

        show(controller, sender: self)
    }

    func showUserVC(with user: User) {

    }

    func showPhotoDetailVC(with photo: Photo) {

    }
}

extension SearchTabFlowController {
    func handlePhotoVCEvent(with event: PhotoVC.Event) {
        switch event {
        case .photoWasLiked:
            print("test")
        case .showDetail(let photo):
            showPhotoDetailVC(with: photo)
        }
    }
}
