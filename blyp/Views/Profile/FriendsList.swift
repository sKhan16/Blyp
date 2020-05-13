//
//  FriendsList.swift
//  blyp
//
//  Created by Hayden Hong on 5/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct FriendsList: View {
    var friends: [FriendProfileSearchable]
    
    init(friends: [FriendProfileSearchable]) {
        UITableView.appearance().separatorColor = nil
        self.friends = friends
    }
    
    init(searchHits: [DisplayNameAlgoliaResult]) {
        UITableView.appearance().separatorColor = .clear
        self.friends = searchHits.map { FriendProfileSearchable(displayName: $0.displayName, uid: $0.objectID) }
    }
    
    var body: some View {
        List(friends) { friend in
            NavigationLink(destination: FriendProfileView(friendProfile: friend)) {
                FriendCell(friend: friend)
            }
        }
    }
}

//struct FriendsList_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsList(friends: )
//    }
//}
