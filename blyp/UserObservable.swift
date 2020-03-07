//
//  UserObservable.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import FirebaseAuth

public class UserObservable: ObservableObject {
    @Published var displayName: String = "DisplayName"
    @Published var loginState: LoginState = .loggedOut
    
    /// Update the user's display name
    /// - Parameter displayName: display name (username) to set it to
    func changeDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        changeRequest?.displayName = trimmedName
        changeRequest?.commitChanges { (error) in
            if error == nil {
                withAnimation {
                    self.displayName = trimmedName
                    self.loginState = .loggedIn
                }
            } else {
                // FIXME: Add error state
            }
        }
    }
    
    /// Logout from Firebase
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            resetUserInfo()
        } catch let signOutError as NSError {
            // No idea wtf happened but we can make sure users don't see information anymore
            resetUserInfo()
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func developerLogin() {
        #if DEBUG
        if let email = ProcessInfo.processInfo.environment["BLYP_EMAIL"] {
            if let password = ProcessInfo.processInfo.environment["BLYP_PASSWORD"] {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    if let authDisplayName = authResult?.user.displayName {
                        self!.displayName = authDisplayName
                        self!.loginState = .loggedIn
                    } else {
                        self?.changeDisplayName(displayName: "BlypUser")
                    }
                }
            } else {
                print("Make sure you have BLYP_PASSWORD in your Xcode environment")
            }
        } else {
            print("Make sure you have BLYP_EMAIL in your Xcode environment")
        }
        #else
        throw "What the FUCK do you think you're doing? You CANNOT use developer login in a release environment"
        #endif
    }
    
    private func resetUserInfo() {
        displayName = ""
        loginState = .loggedOut
    }
}

enum LoginState {
    case loggedIn
    case signingUp
    case loggedOut
}
