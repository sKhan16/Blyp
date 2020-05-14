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
import Foundation
import SwiftUI

public class UserObservable: ObservableObject {
    @Published var displayName: String = "DisplayName"
    @Published var uid: String = ""
    @Published var loginState: LoginState = .loggedOut
    @Published var blyps: BlypsObservable?
    @Published var friends: [FriendProfile] = []
    @Published var legacyContact: String = ""

    private var userProfilesCollectionRef: CollectionReference = Firestore.firestore().collection("userProfiles")
    private var userDisplayNameCollectionRef: CollectionReference = Firestore.firestore().collection("userDisplayNames")
    private var userProfileRef: DocumentReference {
        return userProfilesCollectionRef.document(uid)
    }

    private var userDisplayNameRef: DocumentReference {
        return userDisplayNameCollectionRef.document(uid)
    }

    private var blypFirestoreListenerSubscription: ListenerRegistration?

    init() {
        blyps = BlypsObservable(user: self)
    }

    deinit {
        blypFirestoreListenerSubscription?.remove()
        blyps = nil
    }

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
                self.userDisplayNameRef.updateData(["displayName": trimmedName])
            } else {
                // FIXME: Add error state
            }
        }
    }

    // MARK: Utility functions

    /// Reset all user data
    private func resetUserInfo() {
        displayName = ""
        loginState = .loggedOut
        friends = []
    }

    /// Start the subscription to Blyps on Firestore
    private func subscribeToFirestore() {
        blypFirestoreListenerSubscription = userProfileRef.addSnapshotListener { documentSnapshot, _ in
            let result = Result {
                try documentSnapshot.flatMap {
                    try $0.data(as: UserProfile.self)
                }
            }
            switch result {
            case let .success(profile):
                if let profile = profile {
                    self.getFriendsUsernames(uids: profile.friends)
                    guard let blyps = self.blyps else {
                        print("blyps were not configured in UserObservable")
                        return
                    }
                    self.legacyContact = profile.legacyContact
                    blyps.parse(from: profile, isFromCache: documentSnapshot?.metadata.isFromCache ?? true)
                }
            case let .failure(err): print(err)
                // FIXME: ADD ERROR HANDLING
            }
        }
    }

    private func getFriendsUsernames(uids: [String]) {
        if uids.count == 0 {
            print("No friends to get usernames from right now")
            friends.removeAll()
            return // can't run whereField on empty array
        }
        print("Getting usernames for \(uids)")
        userProfilesCollectionRef.whereField("uid", in: uids).getDocuments { documentsSnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            guard let documents = documentsSnapshot?.documents else {
                print("Error getting friends' usernames: \(String(describing: error))")
                return
            }
            var tempFriends: [FriendProfile] = []
            for document in documents {
                let result = Result {
                    try document.data(as: FriendProfile.self)
                }
                switch result {
                case let .success(friendProfile):
                    if let profile = friendProfile {
                        print("Got username for \(profile.uid): \(profile.displayName ?? "")")
                        tempFriends.append(profile)
                    }
                case let .failure(err): print(err)
                    // FIXME: ADD ERROR HANDLING
                }
            }
            tempFriends.sort()
            self.friends.removeAll()
            self.friends.append(contentsOf: tempFriends)
        }
    }

    func addFriend(_ friendProfile: FriendProfile) {
        userProfileRef.updateData([
            "friends": FieldValue.arrayUnion([friendProfile.uid])
        ])
    }

    func removeFriend(_ friendProfile: FriendProfile) {
        userProfileRef.updateData([
            "friends": FieldValue.arrayRemove([friendProfile.uid])
        ])
    }

    func setLegacyContact(to friendProfile: FriendProfile) {
        userProfileRef.updateData([
            "legacyContact": friendProfile.uid
        ])
    }

    func removeLegacyContact() {
        userProfileRef.updateData([
            "legacyContact": ""
        ])
    }

    func isLegacyContact(of friendProfile: FriendProfile) -> Bool {
        return friendProfile.legacyContact == self.uid
    }

    func set(friend: FriendProfile, as status: DeceasedStatus) {
        let friendProfileDocumentRef = userProfilesCollectionRef.document(friend.uid)
        friendProfileDocumentRef.updateData(["deceased": status == .deceased])
    }
}

enum LoginState {
    case loggedIn
    case signingUp
    case loggedOut
}

enum DeceasedStatus {
    case deceased
    case alive
}
