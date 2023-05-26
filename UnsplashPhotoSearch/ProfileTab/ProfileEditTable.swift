//
//  ProfileEditTable.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 26.05.2023.
//

import UIKit


class EditProfileTableView: UITableView{
    let user: User?

    let fields = [
        "First Name",
        "Last Name",
        "Username",
        "Email",
        "Location"
    ]

    init(user: User?) {
        self.user = user
        super.init(frame: .zero, style: .insetGrouped)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        register(EditProfileTVCell.self, forCellReuseIdentifier: EditProfileTVCell.identifier)
        dataSource = self
        isScrollEnabled = false
        backgroundColor = .Unsplash.dark2
    }
}

extension EditProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVCell.identifier) as! EditProfileTVCell
        cell.configuration(holder: fields[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Profile"
    }
}
