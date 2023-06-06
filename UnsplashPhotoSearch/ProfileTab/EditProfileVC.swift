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

    var onEditEvent: ((EditEvent) -> Void)?
    lazy var userData = [
        user.firstName,
        user.lastName,
        user.username,
        user.location,
        user.biography
    ]

    var editableUserData: EditableUserData = .init()

// MARK: - Initialiser
    private let user: User

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

// MARK: - Events
    private func saveButtonTapped() {
        guard editableUserData.isDataValid() else { return }
        onEditEvent?(.save(editableUserData))
    }

    private func cancelButtonTapped() {
        onEditEvent?(.cancel)
    }
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
            primaryAction: UIAction { [unowned self] _ in self.cancelButtonTapped() }
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
        let field = ProfileField(row: indexPath.row)

        cell.configuration(
            holder: field.placeholder,
            text: userData[indexPath.row]
        )

        cell.onTextChange = { [weak self] text in
            self?.handleText(text, in: field)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Profile"
    }
}

// MARK: - Delegate
extension EditProfileVC {
    func handleText(_ text: String, in field: ProfileField) {
        switch field {
        case .firstName:
            editableUserData.firstName = text
        case .lastName:
            editableUserData.lastName = text
        case .username:
            editableUserData.userName = text
        case .location:
            editableUserData.location = text
        case .biography:
            editableUserData.biography = text
        }
    }

    enum ProfileField: Int {
        case firstName
        case lastName
        case username
        case location
        case biography

        init(row: Int) {
            self.init(rawValue: row)!
        }

        var placeholder: String {
            switch self {
            case .firstName:
                return "First Name"
            case .lastName:
                return "Last Name"
            case .username:
                return "Username"
            case .location:
                return "Location"
            case .biography:
                return "Biography"
            }
        }
    }
    enum EditEvent {
        case save(EditableUserData)
        case cancel
    }
}





