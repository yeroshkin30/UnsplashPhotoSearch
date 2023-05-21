//
//  AuthorizationVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit
import SnapKit

final class AuthorizationVC: UIViewController {
    private let logInButton: UIButton = .init(configuration: .filled())

    private var authorizationController: AuthorizationController = .init()
    private var profileVC: UserVC?

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
                profileVC = .init(user: user)
                profileVC?.modalPresentationStyle = .fullScreen
                present(profileVC!, animated: true)
            } catch {
                print(error)
            }
        }
    }

    private func presentProfile(with: User) {
        show(profileVC!, sender: nil)
    }
}

private extension AuthorizationVC {
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
