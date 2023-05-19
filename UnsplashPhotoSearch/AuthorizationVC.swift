//
//  AuthorizationVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit
import SnapKit
import WebKit

final class AuthorizationVC: UIViewController {

    let logInButton: UIButton = .init(configuration: .filled())

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension AuthorizationVC {
    func setup() {
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

    @objc func startAuthorization() {

    }
}



