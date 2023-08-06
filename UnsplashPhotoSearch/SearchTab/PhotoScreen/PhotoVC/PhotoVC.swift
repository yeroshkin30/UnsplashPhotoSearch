//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit

final class PhotoVC: UIViewController {

    enum Event {
        case showDetail(Photo)
        case photoWasLiked
    }

    var onEvent: ((Event) -> Void)?

    private lazy var mainView: PhotoView = .init(frame: view.bounds)
    private let  networkService: NetworkService = .init()

    // MARK: - Inits
    
    private var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
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
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
}

// MARK: - Private methods

private extension PhotoVC {
    func photoWasLiked() {
        Task {
            do {
                let request = UnsplashRequests.likePhoto(photo: photo, like: !photo.isLiked)
                photo = try await networkService.perform(with: request)
            } catch {
                print(error)
            }
            mainView.configuration = .init(photo: photo)
        }
    }
}

private extension PhotoVC {
    func setup() {
        title = photo.user?.username

        mainView.configuration = .init(photo: photo)
        mainView.onButtonTap = { [weak self] button in
            guard let self else { return }

            switch button {
            case .like:
                photoWasLiked()
            case .info:
                onEvent?(.showDetail(photo))
            }
        }
    }
}
