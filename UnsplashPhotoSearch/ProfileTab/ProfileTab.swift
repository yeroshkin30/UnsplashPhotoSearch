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

    private var authorizationController: AuthorizationController = .init()
    private var profileVC: UserVC!

    private var user: User!
    private let isAutorized = UserDefaults.standard.bool(forKey: "User")

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if isAutorized {
            logIn()
        }
    }

    func logIn() {
        logInButton.isHidden = true

        Task {
            do {
                let newRequest = URLRequest.Unsplash.userProfile()
                user = try await UnsplashNetwork<User>().fetch(from: newRequest)
                setupProfileVC(with: user)
            } catch {
                print(error)
            }
        }
    }

    @objc func startAuthorization() {
        Task {
            do {
                user = try await authorizationController.authorization()
                setupProfileVC(with: user)
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Setup ProfileVC
    private func setupProfileVC(with user: User) {
        profileVC = .init(user: user)
        addChild(profileVC)
        view.addSubview(profileVC.view)
        profileVC?.didMove(toParent: self)

        profileVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        setupNavigationItem()
    }

    private func setupNavigationItem() {
        let editProfileAction = UIAction(
            title: "Edit Profile",
            handler: { _ in self.editActionTapped() }
        )

        let logOutAction = UIAction(
            title: "Log Out",
            handler: { _ in  self.logOutActionTapped()}
        )

        let menuItems = UIMenu(children: [editProfileAction,logOutAction])

        let menuButton = UIBarButtonItem(title: "Settings", image: nil, target: nil, action: nil, menu: menuItems)
        navigationItem.rightBarButtonItem = menuButton
    }

    private func editActionTapped() {
//        let editProfileVC = UINavigationController(rootViewController: EditProfileVC(user: user))
//        present(editProfileVC, animated: true)
    }

    private func logOutActionTapped() {
        UserDefaults.standard.removeObject(forKey: "User")
        UserDefaults.standard.removeObject(forKey: UnsplashAPI.accessTokenKey)
        logInButton.isHidden = false
        profileVC.view.isHidden = true
    }
}

private extension ProfileTabVC {
    func setup() {
        view.backgroundColor = .white
        view.addSubview(logInButton)

        logInButton.configuration?.title = "Log In"
        logInButton.configuration?.buttonSize = .large
        logInButton.addTarget(self, action: #selector(startAuthorization), for: .touchUpInside)

        setupConstraints()
    }

    func setupConstraints() {
        logInButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
        }
    }
}

enum AuthorizationState {
    case authorised
    case unauthorised
    case authorising
}
