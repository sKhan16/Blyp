//
//  FriendCell.swift
//  blyp
//
//  Created by Hayden Hong on 5/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct FriendCell: View {
    @EnvironmentObject var user: UserObservable
    private var profile: FriendProfile

    init(for user: DisplayNameAlgoliaResult) {
        profile = FriendProfile(uid: user.objectID, displayName: user.displayName)
    }

    init(friend: FriendProfile) {
        profile = friend
    }

    var body: some View {
        HStack {
            Text(profile.displayName ?? "Unknown Name")
            Spacer()
            if profile.isLegacyContact(of: user) {
                Image(systemName: "person.crop.circle.badge.checkmark")
            }
            if profile.isAlreadyFriend(of: user) {
                Image(systemName: "person.2")
            }
        }
    }
}

// struct FriendCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendCell()
//    }
// }
