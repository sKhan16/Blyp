//
//  SignInWithAppleToFirebase.swift
//  LoginWithAppleFirebaseSwiftUI
//
//  Created by Joseph Hinkle on 12/15/19.
//  Copyright © 2019 Joseph Hinkle. All rights reserved.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import SwiftUI
import UIKit

final class SignInWithApple: UIViewRepresentable {
    func makeUIView(context _: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .default, style: .whiteOutline)
    }

    func updateUIView(_: ASAuthorizationAppleIDButton, context _: Context) {}
}

enum SignInWithAppleToFirebaseResponse {
    case success
    case error
}

final class SignInWithAppleToFirebase: UIViewControllerRepresentable {
    private var appleSignInDelegates: SignInWithAppleDelegates!
    private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> Void)?
    private var currentNonce: String?

    init(_ onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> Void)? = nil) {
        self.onLoginEvent = onLoginEvent
    }

    func makeUIViewController(context _: Context) -> UIViewController {
        let vc = UIHostingController(rootView: SignInWithApple().onTapGesture(perform: showAppleLogin))
        return vc as UIViewController
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}

    private func showAppleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        performSignIn(using: [request])
    }

    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        guard let currentNonce = self.currentNonce else {
            return
        }
        appleSignInDelegates = SignInWithAppleDelegates(window: nil, currentNonce: currentNonce, onLoginEvent: onLoginEvent)

        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = appleSignInDelegates
        authorizationController.presentationContextProvider = appleSignInDelegates
        authorizationController.performRequests()
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if length == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

class SignInWithAppleDelegates: NSObject {
    private let onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> Void)?
    private weak var window: UIWindow!
    private var currentNonce: String? // Unhashed nonce.

    init(window: UIWindow?, currentNonce: String, onLoginEvent: ((SignInWithAppleToFirebaseResponse) -> Void)? = nil) {
        self.window = window
        self.currentNonce = currentNonce
        self.onLoginEvent = onLoginEvent
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    func firebaseLogin(credential: ASAuthorizationAppleIDCredential) {
        // 3
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { _, error in
            if error != nil {
                // Error. If error.code == .MissingOrInvalidNonce, make sureM

                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error?.localizedDescription ?? "")
                self.onLoginEvent?(.error)
                return
            }
            // User is signed in to Firebase with Apple.
            print("you're in")
            self.onLoginEvent?(.success)
        }
    }

    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        // 1
        let userData = UserData(email: credential.email!,
                                name: credential.fullName!,
                                identifier: credential.user)

        // 2
        let keychain = UserDataKeychain()
        do {
            try keychain.store(userData)
        } catch {}

        // 3
        firebaseLogin(credential: credential)
    }

    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        firebaseLogin(credential: credential)
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credential: appleIdCredential)
            } else {
                signInWithExistingAccount(credential: appleIdCredential)
            }
        default:
            break
        }
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) {
        onLoginEvent?(.error)
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
}
