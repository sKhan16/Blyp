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
