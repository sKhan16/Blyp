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
    private var profile: FriendProfileSearchable
    
    init(for user: DisplayNameAlgoliaResult) {
        self.profile = FriendProfileSearchable(displayName: user.displayName, uid: user.objectID)
    }
    init(friend: FriendProfileSearchable) {
        self.profile = friend
    }
    var body: some View {
        HStack {
            Text(profile.displayName ?? "Unknown Name")
            Spacer()
            if (profile.isLegacyContact(of: user)) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .padding(.trailing)
            }
            if (profile.isAlreadyFriend(of: user)) {
                Image(systemName: "person.2")
                    .padding(.trailing)
            }
        }
    }
}

//struct FriendCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendCell()
//    }
//}
