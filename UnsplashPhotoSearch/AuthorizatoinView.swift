//
//  AuthorizatoinView.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit
import SnapKit

class AuthorizationView: UIView {
    let usernameTextField: UITextField = .init()
    let passwordTextField: UITextField = .init()
    let logInButton: UIButton = .init(configuration: .bordered())
    let stackView: UIStackView = .init()


    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .white
        addSubview(stackView)


        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(logInButton)

        setupConstraints()
    }

    func setupButton() {
    }

    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
