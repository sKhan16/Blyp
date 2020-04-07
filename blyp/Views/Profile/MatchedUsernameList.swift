//
//  MatchedUsernameList.swift
//  blyp
//
//  Created by Hayden Hong on 3/30/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct MatchedUsernameList: View {
    @Binding var searchQuery: String
    var userSearcher = UserSearcher()
    var body: some View {
        List {
            ForEach(userSearcher.search(query: searchQuery).displayNameAlgolia.hits, id:\.self) {
                hits in Text(hits.displayName)
            }
        }
    }
}

/// FIXME
//struct MatchedUsernameList_Previews: PreviewProvider {
//    static var previews: some View {
//        MatchedUsernameList(usernames: ["Bob", "Sabby"])
//    }
//}
