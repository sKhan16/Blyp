//
//  BlypsObservable.swift
//  blyp
//
//  Created by Hayden Hong on 4/21/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class BlypsObservable: ObservableObject {
    var user: UserObservable?
    @Published var list: [Blyp] = []
    
    private let storage = Storage.storage()
    private let databaseName: String = "userProfiles"
    
    private let imageExtension = "jpeg"
    
    init(user: UserObservable) {
        self.user = user
    }
    
    /// Saves the Blyp to the user's account
    /// - Parameter blyp: Blyp to save
    func addBlyp(_ blyp: Blyp) {
        guard let user = self.user else {
            print("user not assigned in BlypsObservable")
            return
        }
        
        // Store the image in the Firebase Cloud Storage bucket
        if (blyp.image != nil) {
            let storageRef = storage.reference()
            let imageChild = "\(user.uid)/\(blyp.id).\(imageExtension)"
            let imageRef = storageRef.child(imageChild)
            let imageData = (blyp.image?.jpegData(compressionQuality: 0.5))!
            
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                // Copying is required because blyp is immutable
                var blypWithImageUrl = blyp
                
                // blypWithImageUrl.imageUrl = url.absoluteString
                
                // Make image tiny and then create a blur hash in a new thread
                let queue = OperationQueue()
                queue.addOperation {
                    if (blyp.image!.size.height > 128 || blyp.image!.size.width > 128) {
                        blypWithImageUrl.imageBlurHash = blyp.image!.resizeImage(128.0, opaque: false).blurHash(numberOfComponents: (4,4))
                    } else {
                        blypWithImageUrl.imageBlurHash = blyp.image!.blurHash(numberOfComponents: (4,4))
                    }
                    
                    
                    imageRef.downloadURL {(url, error) in
                        if (error != nil) {print(error)}
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
                "imageUrl": blyp.imageUrl,
                "imageBlurHash": blyp.imageBlurHash,
                "imageBlurHashHeight": blyp.imageBlurHashHeight,
                "imageBlurHashWidth": blyp.imageBlurHashWidth
            ],
        ]) { err in
            if let err = err {
                print("Error saving \(blyp.id): \(err)")
            } else {
                print("Blyp \(blyp.id) saved")
            }
        }
    }
    
    /// Parses blyps from incoming profile and sets to $list
    /// - Parameter userProfile: Profile to parse blyps from
    func parse(from userProfile: UserProfile) {
        var tempBlyps: [Blyp] = []
        let db = Firestore.firestore()
        
//        db.collection("userProfiles").document("HtXEsbEJbabtoFdk9GxrsavhsjE3").getDocument { documentSnapshot, error in
//            let result = Result {
//                try documentSnapshot.flatMap {
//                    try $0.data(as: UserProfile.self)
//                }
//            }
//            switch result {
//            case let .success(profile):
//                if let profile = profile {
//                    print(profile)
//                }
//            case let .failure(err): print(err)
//                // FIXME: ADD ERROR HANDLING
//            }
//        }
        
        db.collection("userProfiles").whereField("uid", in: userProfile.friends).getDocuments { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching Friends' blyps: \(error!)")
              return
            }

            print("Current data: \(document.documents)")
        }

        for (_, blyp) in userProfile.blyps {
            tempBlyps.append(blyp)
        }
        tempBlyps.sort { (a, b) -> Bool in
            a.createdOn > b.createdOn
        }
        self.list = tempBlyps
        print("Blyps have been updated LIVE!")
    }
    
    init() {
        self.list = []
    }
}
