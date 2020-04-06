//
//  UserSearcher.swift
//  blyp
//
//  Created by Hayden Hong on 4/5/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class UserSearcher: ObservableObject {
    @EnvironmentObject var user: UserObservable
    
    @Published var userNames: [String] = []
    
    private let databaseName: String = "userDisplayNames"
    
    init () {
    }

    func search(query: String) -> Self {
        let db = Firestore.firestore()
        let splitQuery = query.lowercased().split(separator: " ")
        let dbQueryBuildable = db.collection(databaseName)
        splitQuery.forEach { section in
            dbQueryBuildable.whereField("searchable", arrayContainsAny: [String(section)])
        }

        dbQueryBuildable.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let displayName = document.data()["displayName"] as! String
                    self.userNames.append(displayName)
                }
            }
        }
        return self
    }
}
