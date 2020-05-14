//
//  AddFriends.swift
//  blyp
//
//  Created by Hayden Hong on 5/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct AddFriends: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserObservable
    @ObservedObject var userSearcher: UserSearcher // = UserSearcher()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(userSearcher: self.userSearcher)
                FriendsList(searchHits: userSearcher.displayNameAlgolia.hits)
                    .navigationBarTitle("Add Friends")
                    .navigationBarItems(leading: CloseButton(presentationMode: presentationMode))
            }
        }.modifier(TableViewLine(is: .shown))
    }
}

// struct AddFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFriends()
//    }
// }
