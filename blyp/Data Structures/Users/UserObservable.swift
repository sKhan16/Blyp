//
//  UserObservable.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions
import Foundation
import SwiftUI

public class UserObservable: ObservableObject {
    @Published var displayName: String = "DisplayName"
    @Published var uid: String = ""
    @Published var loginState: LoginState = .loggedOut
    @Published var blyps: [Blyp] = []
    @Published var friends: [FriendProfile] = []

    private lazy var functions = Functions.functions()

    private let databaseName: String = "userProfiles"
    private var blypFirestoreListenerSubscription: ListenerRegistration?

    // MARK: Authentication and Login/Logout functions

    /// Set our Observable's values to the incoming User's values
    func completeLogin(user: User) {
        if let displayName = user.displayName {
            self.displayName = displayName
            loginState = .loggedIn
        } else {
            loginState = .signingUp
        }
        uid = user.uid
        subscribeToFirestore()
    }

    /// Logout from Firebase
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            resetUserInfo()
            // Remove the subscription to the Blyp database
            blypFirestoreListenerSubscription?.remove()
            blypFirestoreListenerSubscription = nil
        } catch let signOutError as NSError {
            // No idea wtf happened but we can make sure users don't see information anymore
            resetUserInfo()
            print("Error signing out: %@", signOutError)
        }
    }

    func developerLogin() {
        #if DEBUG
            if let email = ProcessInfo.processInfo.environment["BLYP_EMAIL"] {
                if let password = ProcessInfo.processInfo.environment["BLYP_PASSWORD"] {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, _ in
                        // Forcing this is okay because it's debug. If something breaks here.... we're doomed
                        self.completeLogin(user: authResult!.user)
                    }
                } else {
                    print("Make sure you have BLYP_PASSWORD in your Xcode environment")
                }
            } else {
                print("Make sure you have BLYP_EMAIL in your Xcode environment")
            }
        #else
            print("What the FUCK do you think you're doing? You CANNOT use developer login in a release environment")
        #endif
    }

    // MARK: Functions that edit user's data

    /// Update the user's display name
    /// - Parameter displayName: display name (username) to set it to
    func changeDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        changeRequest?.displayName = trimmedName
        changeRequest?.commitChanges { error in
            if error == nil {
                self.displayName = trimmedName
                self.loginState = .loggedIn
                Firestore.firestore().collection("userDisplayNames").document(self.uid).setData(["displayName": trimmedName])
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
        blypFirestoreListenerSubscription = db.collection(databaseName).document(uid)
            .addSnapshotListener { documentSnapshot, _ in
                let result = Result {
                    try documentSnapshot.flatMap {
                        try $0.data(as: UserProfile.self)
                    }
                }
                switch result {
                case let .success(profile):
                    if let profile = profile {
                        var tempBlyps: [Blyp] = []
                        for (_, blyp) in profile.blyps {
                            tempBlyps.append(blyp)
                        }
                        tempBlyps.sort { (a, b) -> Bool in
                            a.name < b.name
                        }
                        self.blyps = tempBlyps
                        self.friends = profile.friends.map { FriendProfile(uid: $0) }
                        print("Blyps have been updated LIVE!")
                    }

                case let .failure(err): print(err)
                    // FIXME: ADD ERROR HANDLING
                }
            }
    }

    /// Add to the database using the "addBlyp" function
    func addBlyp(_ blyp: Blyp) {
        let db = Firestore.firestore()
        // FIXME: This is bad, we should be doing different collections entirely
        db.collection(databaseName).document(uid).updateData([
            "blyps.\(blyp.id)": [
                "id": blyp.id.uuidString,
                "name": blyp.name,
                "description": blyp.description,
                "image": blyp.image,
            ],
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    func addFriend(_ friendProfile: FriendProfile) {
        let db = Firestore.firestore()
        db.collection(databaseName).document(uid).updateData([
            "friends": FieldValue.arrayUnion([friendProfile.uid]),
        ])
    }
}

enum LoginState {
    case loggedIn
    case signingUp
    case loggedOut
}

/// Names of Firebase Functions
enum Funcs: String {
    case addBlyp
    case removeBlyp
}