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
    
    init(user: UserObservable) {
        self.user = user
    }
    
    func addBlyp(_ blyp: Blyp) {
        let db = Firestore.firestore()
    
        guard let user = self.user else {
            print("user not assigned in BlypsObservable")
            return
        }
        
        // FIXME: This is bad, we should be doing different collections entirely
        if (blyp.imageData != nil) {
            let storageRef = storage.reference()
            let imageRef = storageRef.child("\(user.uid)/\(blyp.id).jpeg")
            imageRef.putData(blyp.imageData ?? Data(), metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Handle this error
                    return
                }
                imageRef.downloadURL { (url, error) in
                    // Should uhhhh we have this url or what
                }
            }
        }
        
        db.collection(databaseName).document(user.uid).updateData([
            "blyps.\(blyp.id)": [
                "id": blyp.id.uuidString,
                "name": blyp.name,
                "description": blyp.description
                // "image": blyp.image,
            ],
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    /// Parses blyps from incoming profile and sets to $list
    /// - Parameter userProfile: Profile to parse blyps from
    func parse(from userProfile: UserProfile) {
        var tempBlyps: [Blyp] = []
        for (_, blyp) in userProfile.blyps {
            tempBlyps.append(blyp)
        }
        tempBlyps.sort { (a, b) -> Bool in
            a.name < b.name
        }
        self.list = tempBlyps
        print("Blyps have been updated LIVE!")
    }
    
    init() {
        self.list = []
    }
}
