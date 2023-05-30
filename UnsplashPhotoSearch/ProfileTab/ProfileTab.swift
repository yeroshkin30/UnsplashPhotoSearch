//
//  ProfileTabVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit
import SnapKit

final class ProfileTabVC: UIViewController {
    private let logInButton: UIButton = .init(configuration: .filled())
    private let loadingView: UIActivityIndicatorView = .init()
    private var authorizationController: AuthorizationController
    private var profileVC: UserVC!

    var onEvent: ((User) -> Void)?
    private var user: User!

    init(with authorizationController: AuthorizationController) {
        self.authorizationController = authorizationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        authorizationController.checkAuthStatus()
    }

    private func logInButtonTapped() {
        Task {
            try? await authorizationController.performAuthorization()
        }
    }

    // MARK: - UIMenuActions
    private func editButtonTapped() {
        let editProfileVC = UINavigationController(rootViewController: EditProfileVC(user: user))
        present(editProfileVC, animated: true)
    }

    private func logOutButtonTapped() {
        authorizationController.performLogOut()
    }

    // MARK: - Setup ProfileVC
    private func setupProfileVC(with user: User) {
        profileVC = .init(user: user)

        addChildVC(profileVC)
        profileVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        setupNavigationItem()
        loadingView.isHidden = true
    }

    private func setupNavigationItem() {
        let editProfileAction = UIAction(
            title: "Edit Profile",
            handler: { _ in self.editButtonTapped() }
        )

        let logOutAction = UIAction(
            title: "Log Out",
            handler: { _ in  self.logOutButtonTapped()}
        )

        let menuItems = UIMenu(children: [editProfileAction,logOutAction])

        let menuButton = UIBarButtonItem(title: "Settings", image: nil, target: nil, action: nil, menu: menuItems)
        navigationItem.rightBarButtonItem = menuButton
    }
}

private extension ProfileTabVC {
    func setup() {
        tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        view.backgroundColor = .white
        view.addSubview(logInButton)
        view.addSubview(loadingView)

        loadingView.isHidden = true
        logInButton.configuration?.title = "Log In"
        logInButton.configuration?.buttonSize = .large
        logInButton.addAction(UIAction { [weak self] _ in self?.logInButtonTapped() }, for: .touchUpInside)
        setupEvents()
        setupConstraints()
    }

    func setupEvents() {
        authorizationController.onAuthChange = { [weak self] state in
            switch state {
            case .authorized(let user):
                self?.setupProfileVC(with: user)
            case .authorizing:
                self?.logInButton.isHidden = true
                self?.loadingView.isHidden = false
            case .unauthorized:
                self?.userIsUnauthorized()
            }
        }
    }

    func userIsUnauthorized() {
        logInButton.isHidden = false
        loadingView.isHidden = true
        removeChildVC(profileVC)
    }

    func setupConstraints() {
        logInButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }

        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}


