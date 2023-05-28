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
    private var authorizationController: AuthorizationController = .init()
    private var profileVC: UserVC!

    private var user: User!
    private var authorizationState: AuthorizationState = .unauthorized {
        didSet {
            authorizationStatesDidChange()
            viewsIsHidden(for: authorizationState)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        authorizationState = authorizationController.authorizationState()
    }

    func authorizationStatesDidChange() {
        Task {
            do {
                switch authorizationState {
                case .authorized:
                    user = try await authorizationController.loadAuthorizedUser()
                    setupProfileVC(with: user)

                case .unauthorized:
                    return
                case .authorizing:
                    user = try await authorizationController.performAuthorization()
                    setupProfileVC(with: user)
                case .unauthorizing:
                    authorizationController.performLogOut()
                }
            } catch {
                print(error)
            }
        }
    }

    private func logInButtonTapped() {
        authorizationState = .authorizing
    }

    // MARK: - UIMenuActions
    private func editButtonTapped() {
        let editProfileVC = UINavigationController(rootViewController: EditProfileVC(user: user))
        present(editProfileVC, animated: true)
    }

    private func logOutButtonTapped() {
        authorizationState = .unauthorizing
        removeChildVC(profileVC)

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
        view.backgroundColor = .white
        view.addSubview(logInButton)
        view.addSubview(loadingView)

        loadingView.isHidden = true
        logInButton.configuration?.title = "Log In"
        logInButton.configuration?.buttonSize = .large
        logInButton.addAction(UIAction { [weak self] _ in self?.logInButtonTapped() }, for: .touchUpInside)

        setupConstraints()
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

extension ProfileTabVC {
    enum AuthorizationState {
        case authorized
        case unauthorized
        case authorizing
        case unauthorizing
    }

    private func viewsIsHidden(for state: AuthorizationState) {
        switch state {
        case .authorized:
            logInButton.isHidden = true
            loadingView.isHidden = true
        case .unauthorized:
            logInButton.isHidden = false
            loadingView.isHidden = true
        case .authorizing, .unauthorizing:
            logInButton.isHidden = true
            loadingView.isHidden = false
        }
    }
}


