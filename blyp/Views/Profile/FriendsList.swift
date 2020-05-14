//
//  FriendsList.swift
//  blyp
//
//  Created by Hayden Hong on 5/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//
import SwiftUI

struct FriendsList: View {
    var friends: [FriendProfile]
    
    @State private var isSearchable = false
    init(friends: [FriendProfile]) {
        UITableView.appearance().separatorColor = nil
        self.friends = friends
    }
    
    init(searchHits: [DisplayNameAlgoliaResult]) {
        UITableView.appearance().separatorColor = .clear
        self.friends = searchHits.map { FriendProfile(uid: $0.objectID, displayName: $0.displayName) }
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
