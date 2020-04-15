//
//  UserSearcher.swift
//  blyp
//
//  Created by Hayden Hong on 4/5/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import InstantSearchClient
import ObjectMapper
import SwiftUI
import Combine

class UserSearcher: ObservableObject {
    
    typealias Input = String
    typealias Failure = Never
    
    @EnvironmentObject var user: UserObservable
    @Published var searchQuery: String = ""
    @Published var displayNameAlgolia: DisplayNameAlgoliaContent = DisplayNameAlgoliaContent(hits: [])
    
    private var searchWorker: AnyCancellable? = nil
    
    private let databaseName: String = "userDisplayNames"
    
    // MARK: Algolia environment variables. Make sure these are set in your build environment.
    
    private let algoliaAppID: String = ProcessInfo.processInfo.environment["ALGOLIA_APP_ID"]!
    private let algoliaSearchApiKey: String = ProcessInfo.processInfo.environment["ALGOLIA_API_KEY"]!
    
    init() {
        searchWorker = $searchQuery.debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [unowned self] newSearchQuery in
                self.search(query: newSearchQuery)
        }
    }
    
    /// Searches Algolia for the profile
    /// - Parameter query: search query
    func search(query: String)  {
        if query == "" {
            displayNameAlgolia.hits = []
            return
        }
        
        let client = Client(appID: algoliaAppID, apiKey: algoliaSearchApiKey)
        let index = client.index(withName: "prod_DISPLAY_NAMES")
        index.search(Query(query: query), completionHandler: { (content, error) -> Void in
            if error == nil {
                let result = DisplayNameAlgoliaContent(JSON: content!)
                self.displayNameAlgolia = result ?? DisplayNameAlgoliaContent(hits: [])
            }
        })
    }
}

struct DisplayNameAlgoliaContent: Mappable, Hashable {
    init?(map _: Map) {}
    
    init(hits: [DisplayNameAlgoliaResult]) {
        self.hits = hits
    }
    
    mutating func mapping(map: Map) {
        hits <- map["hits"]
    }
    
    var hits: [DisplayNameAlgoliaResult]!
}

struct DisplayNameAlgoliaResult: Mappable, Hashable, Identifiable {
    var id: UUID = UUID()
    
    init?(map _: Map) {}
    
    mutating func mapping(map: Map) {
        displayName <- map["displayName"]
        objectID <- map["objectID"]
    }
    
    var displayName: String!
    var objectID: String!
}
