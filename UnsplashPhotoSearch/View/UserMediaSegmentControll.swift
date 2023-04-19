//
//  UserPhotosView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 08.04.2023.
//

import UIKit

class UserMediaSegmentControll: UISegmentedControl {

    init () {
        super.init(frame: CGRect())
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupSegmentedControl()
    }

    private func setupSegmentedControl() {
        insertSegment(withTitle: "Photos", at: 0, animated: false)
        insertSegment(withTitle: "Likes", at: 1, animated: false)
        insertSegment(withTitle: "Collections", at: 2, animated: false)
        selectedSegmentIndex = 0
    }
}
