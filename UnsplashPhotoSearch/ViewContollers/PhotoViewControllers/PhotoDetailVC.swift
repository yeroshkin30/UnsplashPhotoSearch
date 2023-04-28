//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit

class PhotoDetailVC: UIViewController {
    lazy var photoDetailView = PhotoDetailView(location: location)
    let location: Location
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension PhotoDetailVC {

    @objc func doneButtonPressed() {
        dismiss(animated: true)
    }

    func setup() {
        navigationItem.setLeftBarButton(
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed)),
            animated: true
        )
        title = "Info"
        view.addSubview(photoDetailView)
        view.backgroundColor = .gray

        setupConstraints()
    }
    
    func setupConstraints() {
        photoDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
