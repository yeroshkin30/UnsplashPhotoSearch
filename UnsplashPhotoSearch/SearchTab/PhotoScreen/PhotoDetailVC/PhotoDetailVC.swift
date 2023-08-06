//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit

final class PhotoDetailVC: UIViewController {

    var onDismissEvent: (() -> Void)?

    private let mainView = PhotoDetailView()
    private let location: Location?

    // MARK: -  Inits

    init(location: Location?) {
        self.location = location
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

private extension PhotoDetailVC {

    @objc func doneButtonPressed() {
        onDismissEvent?()
    }

    func setup() {
        navigationItem.setLeftBarButton(
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed)),
            animated: true
        )
        title = "Info"

        if let location {
            mainView.locationSetup(location: location)
        }
    }
}
