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
        authorizationSetup()
    }

    @objc func startAuthorization() {

        Task {
            let user = try? await authorizationController.getUser()
print(user)
        }
    }

    private func presentProfile(with: User) {
        show(profileVC!, sender: nil)
    }
}

private extension AuthorizationVC {
    func authorizationSetup() {
        view.backgroundColor = .white
        view.addSubview(logInButton)

        logInButton.configuration?.title = "Log In"
        logInButton.configuration?.buttonSize = .large
        logInButton.addTarget(self, action: #selector(startAuthorization), for: .touchUpInside)

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
