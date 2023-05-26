//
//  EditProfileVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 25.05.2023.
//

import UIKit
import SnapKit

class EditProfileVC: UIViewController {
    let tableView = EditProfileTableView(user: nil)
//    let user: User
//
//    init(user: User) {
//        self.user = user
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        view.backgroundColor = .Unsplash.dark2
        view.addSubview(tableView)
        setupNavigationItem()
        setupConstraints()
    }

    func setupNavigationItem() {
        navigationItem.title = "Edit Profile"

        let saveButton = UIBarButtonItem(
            systemItem: .save,
            primaryAction: UIAction { _ in self.saveButtonTapped() }
        )
        
        let cancelButoon = UIBarButtonItem(
            systemItem: .cancel,
            primaryAction: UIAction { _ in self.dismiss(animated: true) }
        )

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButoon
    }

    func saveButtonTapped() {

    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(0)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
