//
//  AuthorizationVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit
import AuthenticationServices


class AuthorizationController: NSObject {
    private var session: ASWebAuthenticationSession?

    func requestAuthorizationCode() {
        let handler: ASWebAuthenticationSession.CompletionHandler = { successURL, error in
            guard let successURL else { return }

            let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems

            if let code = queryItems?.filter({$0.name == "code"}).first?.value {
                self.requestAccessToken(with: code)
            } else {
                print(error?.localizedDescription ?? "Error with Auth")
            }
        }

        session = ASWebAuthenticationSession(
            url: UnsplashAPI.logInURL,
            callbackURLScheme: nil,
            completionHandler: handler
        )
        session?.presentationContextProvider = self

        session?.start()
    }

    func requestAccessToken(with code: String) {
        let request = URLRequest.Unsplash.userToken(with: code)

        Task {
            do {
                let token = try await TokenNetwork().fetchToken(from: request)
                UserDefaults.standard.set(token, forKey: UnsplashAPI.accessTokenKey)
            } catch {
                print(error)
            }
        }
    }
}

extension AuthorizationController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
