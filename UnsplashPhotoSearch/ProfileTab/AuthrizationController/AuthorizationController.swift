

import UIKit
import AuthenticationServices

@MainActor
final class AuthorizationController: NSObject {
    private var webAuthSession: ASWebAuthenticationSession?
    private let isAuthorized = UserDefaults.standard.bool(forKey: UnsplashAPI.authorizationState)

    private(set) var authState: AuthorizationState = .unauthorized {
        didSet {
            onEvent?(authState)
        }
    }

    var onEvent: ((AuthorizationState) -> Void)?

    let networkService: NetworkService = .init()

    func checkAuthStatus() {
        Task {
            do {
                if isAuthorized {
                    authState = .authorizing
                    try await loadAuthorizedUser()
                } else {
                    authState = .unauthorized
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Load and update User
    func loadAuthorizedUser() async throws  {
        let urlRequest = UnsplashRequests.userProfile()
        let user = try await networkService.perform(with: urlRequest)
        authState = .authorized(user)
    }

    func updateUserProfile(with data: EditableUserData) async throws {
        let request = UnsplashRequests.editUserProfile(with: data)

        let user = try await networkService.perform(with: request)
        print(user)
        onEvent?(.updated(user))
    }


// MARK: - Authorization
    func performAuthorization() async throws {
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
        try await loadAuthorizedUser()

    }

    private func requestAuthorizationCode(handler: @escaping (Result<String, Error>) -> Void) {
        let handler: ASWebAuthenticationSession.CompletionHandler = { [weak self] successURL, error in
            guard let successURL else { return }

            let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems

            if let code = queryItems?.filter({$0.name == "code"}).first?.value {
                self?.authState = .authorizing
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
        webAuthSession?.prefersEphemeralWebBrowserSession = true

        webAuthSession?.start()
    }

    private func requestAccessToken(with code: String) async throws {
        let urlRequest = UnsplashRequests.userToken(with: code)
        let token = try await networkService.perform(with: urlRequest)
        UserDefaults.standard.set(token.access_token, forKey: UnsplashAPI.accessTokenKey)
        UserDefaults.standard.set(true, forKey: UnsplashAPI.authorizationState)
    }

    // MARK: - Logout
    func performLogOut() {
        cleanAuthorizationData()
        authState = .unauthorized
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
        case authorized(User)
        case unauthorized
        case authorizing
        case updated(User)
    }
}
