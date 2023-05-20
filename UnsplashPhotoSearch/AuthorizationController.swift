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


    func getUser() async throws -> User {
        let code: String =  await  withUnsafeContinuation({ continuation in
            requestAuthorizationCode { code in
                continuation.resume(returning: code)
            }
        })
        let user = try await requestAccessToken(with: code)
        
        return user
    }
    func requestAuthorizationCode(handler: @escaping (String) -> Void) {
        let handler: ASWebAuthenticationSession.CompletionHandler = { successURL, error in
            guard let successURL else { return }

            let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems

            if let code = queryItems?.filter({$0.name == "code"}).first?.value {
                handler(code)
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

    func requestAccessToken(with code: String) async throws -> User {
        let request = URLRequest.Unsplash.userToken(with: code)
        let token = try await UnsplashNetwork<Token>().fetch(from: request)
        UserDefaults.standard.set(token.access_token, forKey: UnsplashAPI.accessTokenKey)

        let newRequest = URLRequest.Unsplash.userProfile()
        let user = try await UnsplashNetwork<User>().fetch(from: newRequest)

        return user
    }
}

extension AuthorizationController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
