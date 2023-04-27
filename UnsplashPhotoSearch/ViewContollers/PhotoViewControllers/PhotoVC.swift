//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 31.03.2023.
//

import UIKit
import SnapKit


class PhotoVC: UIViewController {
    private lazy var photoView: PhotoView = .init()

    var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        update()
    }

    func update() {

        Task {
            photoView.configuration = .init(photo: self.photo)
            self.photo = try await PhotoDataRequest().fetchPhotoData(photoId: photo.id)
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

        photoView.infoButtonEvent = {
            let detailVC = PhotoDetailVC(location: self.photo.location!)
            self.present(UINavigationController(rootViewController: detailVC), animated: true)
        }

    }
}
