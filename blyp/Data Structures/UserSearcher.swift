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
import InstantSearchClient
import ObjectMapper

class UserSearcher: ObservableObject {
    @EnvironmentObject var user: UserObservable
    
    @Published var displayNameAlgolia: DisplayNameAlgoliaContent = DisplayNameAlgoliaContent(hits: [])
    private let databaseName: String = "userDisplayNames"
    
    init () {
    }

    func search(query: String) -> Self {
        if query.count == 0 {
            displayNameAlgolia.hits = []
            return self
        }
        
        // FIXME: Remove these values
        let client = Client(appID: "B9RHB89CNZ", apiKey: "df4f662660088b9929455429c535fd98")
        let index = client.index(withName: "prod_DISPLAY_NAMES")
        index.search(Query(query: query), completionHandler: { (content, error) -> Void in
            if error == nil {
                let result = DisplayNameAlgoliaContent.init(JSON: content!)
                self.displayNameAlgolia = result ?? DisplayNameAlgoliaContent(hits: [])
            }
        })
        return self
    }
}

struct DisplayNameAlgoliaContent : Mappable, Hashable {
    init?(map: Map) {
    }
    
    init(hits: [DisplayNameAlgoliaResult]) {
        self.hits = hits
    }
    
    mutating func mapping(map: Map) {
        hits <- map["hits"]
    }
    
    var hits: [DisplayNameAlgoliaResult]!
}
struct DisplayNameAlgoliaResult : Mappable, Hashable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        displayName <- map["displayName"]
        objectID    <- map["objectID"]
    }
    
    var displayName: String!
    var objectID: String!
}
