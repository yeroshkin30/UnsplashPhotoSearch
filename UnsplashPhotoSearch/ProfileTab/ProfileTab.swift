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

    var user: User?
    var state: AuthorizationState = .unauthorised {
        didSet{

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @objc func startAuthorization() {

        Task {
            do {
                let user = try await authorizationController.authorization()
                setupProfileVC(with: user)
            } catch {
                print(error)
            }
        }
    }

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

        let menuButton = UIBarButtonItem(title: "Edit", image: nil, target: nil, action: nil, menu: menuItems)
        navigationItem.rightBarButtonItem = menuButton
    }

    private func editActionTapped() {
        show(ProfileEditVC(), sender: nil)
    }

    private func logOutActionTapped() {

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
