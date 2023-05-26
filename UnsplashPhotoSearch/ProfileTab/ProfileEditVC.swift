//
//  ProfileEditVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 25.05.2023.
//

import UIKit
import SnapKit

class ProfileEditVC: UIViewController {
    let editView = EditProfileTableView(user: nil)

    let tableView: UITableView = .init(frame: .zero, style: .insetGrouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(editView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()

    }

    func setupConstraints() {
        editView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupTableView() {
        
    }
}
