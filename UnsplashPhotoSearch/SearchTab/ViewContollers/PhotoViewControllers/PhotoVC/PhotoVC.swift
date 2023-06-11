//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit
import SnapKit


class PhotoVC: UIViewController {
    private lazy var photoView: PhotoView = .init(frame: view.bounds)

    var photo: Photo
    var networkService: NetworkService = .init()

    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        setupUI()
        update()
    }

    func update() {
        photoView.configuration = .init(photo: self.photo)


        Task {
            let urlRequest: NetworkRequest<Photo> = UnsplashRequests.singlePhoto(id: .photo(photo.id))
            self.photo = try await networkService.perform(with: urlRequest)
        }
    }

    func photoIsLiked(_ isLiked: Bool) {

        Task {
            do {
                let request = UnsplashRequests.likePhoto(photo: photo, like: isLiked)
                photo = try await networkService.perform(with: request)
                photoView.configuration = .init(photo: self.photo)
            } catch {
                print(error)
            }
        }
    }
}

private extension PhotoVC {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(photoView)
        title = photo.user?.username

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance

        photoView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }

        photoView.onButtonEvent = { [weak self] button in
            switch button {
            case .like(let like):
                self?.photoIsLiked(like)
            case .info:
                let detailVC = PhotoDetailVC(location: self?.photo.location)
                self?.present(UINavigationController(rootViewController: detailVC), animated: true)
            }
        }
    }
}
