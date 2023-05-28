

import UIKit
import AuthenticationServices

@MainActor
final class AuthorizationController: NSObject {
    private var webAuthSession: ASWebAuthenticationSession?
    private let isAuthorized = UserDefaults.standard.bool(forKey: UnsplashAPI.authorizationState)

    private(set) var authorizationState: AuthorizationState = .unauthorized {
        didSet {
            authorizationStatesDidChange()
            viewsIsHidden(for: authorizationState)
        }
    }

    var onAuthChange: ((AuthorizationState) -> Void)?

    func authorizationState() -> ProfileTabVC.AuthorizationState {
        if isAuthorized {
            return .authorized
        } else {
            return .unauthorized
        }
    }

    func loadAuthorizedUser() async throws -> User {
        let newRequest = URLRequest.Unsplash.userProfile()
        let user = try await UnsplashNetwork<User>().fetch(from: newRequest)

        return user
    }

    // MARK: - Authorization
    func performAuthorization() async throws -> User {
        let code: String = try await withUnsafeThrowingContinuation({ continuation in
            requestAuthorizationCode { code in
                switch code {
                case .success(let codes):
                    continuation.resume(returning: codes)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
        try await requestAccessToken(with: code)
        let user = try await loadAuthorizedUser()

        return user
    }

    private func requestAuthorizationCode(handler: @escaping (Result<String, Error>) -> Void) {
        let handler: ASWebAuthenticationSession.CompletionHandler = { successURL, error in
            guard let successURL else { return }

            let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems

            if let code = queryItems?.filter({$0.name == "code"}).first?.value {
                handler(.success(code))
            } else {
                handler(.failure(error!))
            }
        }

        webAuthSession = ASWebAuthenticationSession(
            url: UnsplashAPI.logInURL,
            callbackURLScheme: nil,
            completionHandler: handler
        )
        webAuthSession?.presentationContextProvider = self

        webAuthSession?.start()
    }

    private func requestAccessToken(with code: String) async throws {
        let request = URLRequest.Unsplash.userToken(with: code)
        let token = try await UnsplashNetwork<Token>().fetch(from: request)
        UserDefaults.standard.set(token.access_token, forKey: UnsplashAPI.accessTokenKey)
        UserDefaults.standard.set(true, forKey: UnsplashAPI.authorizationState)
    }

    func performLogOut() {
        let handler: ASWebAuthenticationSession.CompletionHandler = { successURL, error in
                self.cleanAuthorizationData()
                self.webAuthSession?.cancel()

        }

        webAuthSession = ASWebAuthenticationSession.init(
            url: UnsplashAPI.logOutURL,
            callbackURLScheme: "unsplash",
            completionHandler: handler
        )
        webAuthSession?.presentationContextProvider = self

        webAuthSession?.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.webAuthSession?.cancel()
        }
    }

    private func cleanAuthorizationData() {
        UserDefaults.standard.removeObject(forKey: UnsplashAPI.authorizationState)
        UserDefaults.standard.removeObject(forKey: UnsplashAPI.accessTokenKey)
    }
}

extension AuthorizationController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}

extension AuthorizationController {
    enum AuthorizationState {
        case authorized
        case unauthorized
        case authorizing
        case unauthorizing
    }
}
