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
    @State private var friendCanBeAdded = true // just enforce that all be active
    var userSearcher = UserSearcher()
    var body: some View {
        NavigationView {
            List(userSearcher.search(query: searchQuery).displayNameAlgolia.hits) { hit in
                NavigationLink(destination: FriendProfileView(name: hit.displayName)) {
                    Text(hit.displayName)
                }
            }
            .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .navigationBarTitle("")
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct MatchedUsernameList_Previews: PreviewProvider {
    @State static var strBind: String = ""
    static var previews: some View {
        MatchedUsernameList(searchQuery: $strBind)
    }
}
