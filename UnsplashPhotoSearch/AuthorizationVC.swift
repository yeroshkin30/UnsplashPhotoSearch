//
//  AuthorizationVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit
import AuthenticationServices


class AuthorizationVC: UIViewController {
    let authURL = UnsplashAPI.logInURL
    let scheme = UnsplashAPI.callbackUrlScheme

    let session = ASWebAuthenticationSession(
        url: UnsplashAPI.logInURL,
        callbackURLScheme: UnsplashAPI.callbackUrlScheme,
        completionHandler: { callbackURL, error in print(callbackURL) }
        )

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.start()

    }

    func setup() {
        view.backgroundColor = .white

        session.presentationContextProvider = self
    }
}

extension AuthorizationVC: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
