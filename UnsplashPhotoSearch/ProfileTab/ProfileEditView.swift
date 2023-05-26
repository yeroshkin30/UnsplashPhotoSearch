//
//  ProfileEditView.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 25.05.2023.
//

import UIKit
import SnapKit

class ProfileEditView: UIView {
    let firstNameTextField: UITextField = .init()
    let lastNameTextField: UITextField = .init()
    let usernameTextField: UITextField = .init()
    let emailTextField: UITextField = .init()

    let stackView: UIStackView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(stackView)
        setupStackView()
        setupTextFields()
        setupConstraints()
    }

    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        [
            firstNameTextField,
            lastNameTextField,
            usernameTextField,
            emailTextField,
        ].forEach { stackView.addArrangedSubview($0) }
    }

    func setupTextFields() {
        firstNameTextField.text = "First Name"
        lastNameTextField.text = "Last Name"
        usernameTextField.text = "username"
        emailTextField.text = "Email"
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
