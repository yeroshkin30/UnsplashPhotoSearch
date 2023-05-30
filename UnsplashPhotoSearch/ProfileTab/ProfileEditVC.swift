//
//  EditProfileVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 25.05.2023.
//

import UIKit
import SnapKit

class EditProfileVC: UIViewController {
    private let tableView: UITableView = .init(frame: .zero, style: .insetGrouped)
    private let user: User
    private let placeHolders = [
        "First Name",
        "Last Name",
        "Username",
        "Location",
        "Biography"
    ]

    var editableUserData: EditableUserData = .init()

    lazy var userData = [
        user.firstName,
        user.lastName,
        user.username,
        user.biography,
        user.location
    ]

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func saveButtonTapped() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EditProfileTVCell
//        cell.textField.text
    }

    //    func userData() {
    //        let firstName = user.firstName
    //        let lastName = user.lastName
    //        let userName = user.username
    //        let biography = user.biography
    //        let location = user.location
    //    }
}

// MARK: - Setup VC
private extension EditProfileVC {
    func setup() {
        view.backgroundColor = .Unsplash.dark2
        view.addSubview(tableView)

        setupNavigationItem()
        setupTableView()
        setupConstraints()
    }

    func setupNavigationItem() {
        navigationItem.title = "Edit Profile"

        let saveButton = UIBarButtonItem(
            systemItem: .save,
            primaryAction: UIAction { [unowned self] _ in self.saveButtonTapped() }
        )

        let cancelButton = UIBarButtonItem(
            systemItem: .cancel,
            primaryAction: UIAction { [unowned self] _ in self.dismiss(animated: true) }
        )

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(0)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupTableView() {
        tableView.register(EditProfileTVCell.self, forCellReuseIdentifier: EditProfileTVCell.identifier)
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .Unsplash.dark2
    }
}

// MARK: - Data Source
extension EditProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVCell.identifier) as! EditProfileTVCell
        cell.configuration(
            holder: placeHolders[indexPath.row],
            text: userData[indexPath.row]
        )
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Profile"
    }
}

extension EditProfileVC: UITextFieldDelegate {
//    func textChangedInCell(in field: ProfileField, text: String) {
//        switch field {
//        case TextFieldData.firstName.rawValue:
//            editableUserData.firstName = textField.text
//
//        case TextFieldData.lastName.rawValue:
//            editableUserData.lastName = textField.text
//            
//
//        case TextFieldData.username.rawValue:
//            editableUserData.userName = textField.text
//
//        case TextFieldData.location.rawValue:
//            editableUserData.location = textField.text
//
//        case TextFieldData.biography.rawValue:
//            editableUserData.biography = textField.text
//
//        default:
//            return
//        }
//    }
//    enum ProfileField: Int {
//        case firstName = 0
//        case lastName
//        case username
//        case location
//        case biography
//    }
}


