//
//  BlypsObservable.swift
//  blyp
//
//  Created by Hayden Hong on 4/21/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI

class BlypsObservable: ObservableObject {
    var user: UserObservable?
    @Published var personal: [Blyp] = []
    @Published var friends: [Blyp] = []

    private let storage = Storage.storage()
    private var friendBlypSubscription: ListenerRegistration?
    private let databaseName: String = "userProfiles"

    private let imageExtension = "jpeg"

    init(user: UserObservable) {
        self.user = user
    }

    deinit {
        friendBlypSubscription?.remove()
    }

    /// Saves the Blyp to the user's account
    /// - Parameter blyp: Blyp to save
    func addBlyp(_ blyp: Blyp) {
        guard let user = self.user else {
            print("user not assigned in BlypsObservable")
            return
        }

        // Store the image in the Firebase Cloud Storage bucket
        if blyp.image != nil {
            let storageRef = storage.reference()
            let imageChild = "\(user.uid)/\(blyp.id).\(imageExtension)"
            let imageRef = storageRef.child(imageChild)
            let imageData = (blyp.image?.jpegData(compressionQuality: 0.5))!

            imageRef.putData(imageData, metadata: nil) { _, error in
                // Copying is required because blyp is immutable
                var blypWithImageUrl = blyp

                // blypWithImageUrl.imageUrl = url.absoluteString

                // Make image tiny and then create a blur hash in a new thread
                let queue = OperationQueue()
                queue.addOperation {
                    if blyp.image!.size.height > 128 || blyp.image!.size.width > 128 {
                        blypWithImageUrl.imageBlurHash = blyp.image!.resizeImage(128.0, opaque: false).blurHash(numberOfComponents: (4, 4))
                    } else {
                        blypWithImageUrl.imageBlurHash = blyp.image!.blurHash(numberOfComponents: (4, 4))
                    }

                    imageRef.downloadURL { url, error in
                        if error != nil { print(error) }
                        blypWithImageUrl.imageUrl = url?.absoluteString
                        let newScale = blyp.image?.size.scale(to: 32)
                        blypWithImageUrl.imageBlurHashHeight = newScale?.height
                        blypWithImageUrl.imageBlurHashWidth = newScale?.width
                        self.saveBlypToFirebase(blypWithImageUrl)
                    }
                }
            }
        } else {
            saveBlypToFirebase(blyp)
        }
    }

    /// Helper function that manages saving the Blyp to the Firestore database
    /// - Parameter blyp: Blyp to save in the firestore database
    private func saveBlypToFirebase(_ blyp: Blyp) {
        let db = Firestore.firestore()
        // Save the blyp to the Firestore database
        db.collection(databaseName).document(user!.uid).updateData([
            // This MUST adhere to the Blyp struct
            "blyps.\(blyp.id)": [
                "id": blyp.id.uuidString,
                "name": blyp.name,
                "description": blyp.description,
                "createdOn": blyp.createdOn,
                "createdBy": user?.uid,
                "imageUrl": blyp.imageUrl, // Ignore these warnings, we do NOT want to store a default value
                "imageBlurHash": blyp.imageBlurHash,
                "imageBlurHashHeight": blyp.imageBlurHashHeight,
                "imageBlurHashWidth": blyp.imageBlurHashWidth,
                "latitude": blyp.latitude,
                "longitude": blyp.longitude
            ]
        ]) { err in
            if let err = err {
                print("Error saving \(blyp.id): \(err)")
            } else {
                print("Blyp \(blyp.id) saved")
            }
        }
    }

    private func subscribeToFriendBlyps(_ db: Firestore, _ userProfile: UserProfile) {
        friendBlypSubscription?.remove()
        // User must have friends to subscribe, Firebase just fucking kills the app if it is empty
        print("Subscribing to these friends: \(userProfile.friends)")
        if userProfile.friends.count == 0 {
            friends = []
            return
        }
        let userProfilesRef = db.collection("userProfiles")
        friendBlypSubscription = userProfilesRef.whereField("uid", in: userProfile.friends).addSnapshotListener { documentsSnapshot, error in
            self.getBlypsFromFriendsSnapshot(snapshot: documentsSnapshot, error: error)
        }
    }

    /// Parses blyps from incoming profile and sets to $list
    /// - Parameter userProfile: Profile to parse blyps from
    func parse(from userProfile: UserProfile, isFromCache: Bool) {
        let db = Firestore.firestore()
//        if !isFromCache {
            subscribeToFriendBlyps(db, userProfile)
//        }
        personal = userProfile.blyps.values.sorted()
    }

    func getBlypsFromFriendsSnapshot(snapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("Error retreiving collection: \(error)")
        }
        guard let documents = snapshot?.documents else {
            print("Error getting friends' blyps: \(String(describing: error))")
            return
        }

        var tempFriends: [Blyp] = []
        // Go through each profile
        for documentSnapshot in documents {
            // Turn each profile into a UserProfile
            let result = Result {
                try documentSnapshot.data(as: UserProfile.self)
            }
            switch result {
            case let .success(profile):
                if let profile = profile {
                    print("Adding \(profile.blyps.values.count) new items to the friends' list we're building")
                    tempFriends.append(contentsOf: profile.blyps.values)
                }
            case let .failure(err): print(err)
                // FIXME: ADD ERROR HANDLING
            }
        }
        tempFriends.sort()
        friends.removeAll()
        friends.append(contentsOf: tempFriends)
        print("Friends' blyps are now \(friends.count) long")
    }
}
