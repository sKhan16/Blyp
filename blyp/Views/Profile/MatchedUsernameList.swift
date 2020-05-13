//
//  MatchedUsernameList.swift
//  blyp
//
//  Created by Hayden Hong on 3/30/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct MatchedUsernameList: View {
    @ObservedObject var userSearcher: UserSearcher
    var body: some View {
        NavigationView {
            List(userSearcher.displayNameAlgolia.hits) { hit in
                NavigationLink(destination: FriendProfileView(friendProfile: FriendProfileSearchable(displayName: hit.displayName, uid: hit.objectID))) {
                    FriendCell(for: hit)
                }
            }
            .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .navigationBarTitle("")
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct MatchedUsernameList_Previews: PreviewProvider {
    @State static var userSearcher: UserSearcher = UserSearcher()

    static var previews: some View {
        MatchedUsernameList(userSearcher: userSearcher)
    }
}
