//
//  FriendsList.swift
//  blyp
//
//  Created by Hayden Hong on 5/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct FriendsList: View {
    @EnvironmentObject var user: UserObservable
    var body: some View {
        List(user.friends) { friend in
            FriendCell(friend: friend)
        }
    }
}

struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        FriendsList()
    }
}
