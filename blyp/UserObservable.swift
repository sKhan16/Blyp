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
import Firebase
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore
import FirebaseFirestoreSwift

public class UserObservable: ObservableObject {
    @Published var displayName: String = "DisplayName"
    @Published var uid: String = ""
    @Published var loginState: LoginState = .loggedOut
    @Published var blyps: [Blyp] = []
    
    private lazy var functions = Functions.functions()
    
    // MARK: Authentication and Login/Logout functions
    
    /// Set our Observable's values to the incoming User's values
    func completeLogin(user: User) {
        if let displayName = user.displayName {
            self.displayName = displayName
            self.loginState = .loggedIn
        } else {
            self.loginState = .signingUp
        }
        self.uid = user.uid
        self.subscribeToFirestore()
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
    
    // MARK: Functions that edit user's data
    
    /// Update the user's display name
    /// - Parameter displayName: display name (username) to set it to
    func changeDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        changeRequest?.displayName = trimmedName
        changeRequest?.commitChanges { (error) in
            if error == nil {
                self.displayName = trimmedName
                self.loginState = .loggedIn
                
            } else {
                // FIXME: Add error state
            }
        }
    }
    
    // MARK: Utility functions
    
    private func resetUserInfo() {
        displayName = ""
        loginState = .loggedOut
    }
    
    /// Start the subscription to Blyps on Firestore
    private func subscribeToFirestore() {
        let db = Firestore.firestore()
        db.collection("blypDatabase/").document((self.uid))
            .addSnapshotListener { documentSnapshot, error in
                let result = Result {
                    try documentSnapshot.flatMap {
                        try $0.data(as: UserProfile.self)
                    }
                }
                switch result {
                case .success(let profile):
                    if let profile = profile {
                        var tempBlyps: [Blyp] = []
                        for (_, blyp) in profile.blyps {
                            tempBlyps.append(blyp)
                        }
                        tempBlyps.sort { (a, b) -> Bool in
                            a.name < b.name
                        }
                        self.blyps = tempBlyps
                        print("Blyps have been updated LIVE!")
                    }
                    
                case .failure(let err): print(err)
                    // FIXME: ADD ERROR HANDLING
                    
                }
        }
    }
    
    /// Add to the database using the "addBlyp" function
    func addblyp() {
        functions.httpsCallable(Funcs.addBlyp.rawValue).call() { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    // TODO: Add better error handling
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            if let text = (result?.data as? String) {
                self.displayName = text
            }
        }
    }
}

enum LoginState {
    case loggedIn
    case signingUp
    case loggedOut
}

/// Names of Firebase Functions
enum Funcs: String{
    case addBlyp
    case removeBlyp
}
