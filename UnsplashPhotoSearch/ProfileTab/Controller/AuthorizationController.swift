

import UIKit
import AuthenticationServices

@MainActor
final class AuthorizationController: NSObject {
    private var session: ASWebAuthenticationSession?

    func authorization() async throws -> User {
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
        let user = try await requestAccessToken(with: code)
        
        return user
    }

    func requestAuthorizationCode(handler: @escaping (Result<String, Error>) -> Void) {
        let handler: ASWebAuthenticationSession.CompletionHandler = { successURL, error in
            guard let successURL else { return }

            let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems

            if let code = queryItems?.filter({$0.name == "code"}).first?.value {
                handler(.success(code))
            } else {
                handler(.failure(error!))
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
        UserDefaults.standard.set(true, forKey: "User")

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
