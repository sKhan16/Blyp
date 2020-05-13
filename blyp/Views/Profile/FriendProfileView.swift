//
//  FriendProfileView.swift
//  blyp
//
//  Created by Hayden Hong on 4/6/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct FriendProfileView: View {
    @EnvironmentObject var user: UserObservable
    var friendProfile: FriendProfileSearchable
    
    init(friendProfile: FriendProfileSearchable) {
        self.friendProfile = friendProfile
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Here's some information about \(friendProfile.displayName ?? "")")
                Spacer()
                Button(action: {
                    if self.friendProfile.isAlreadyFriend(of: self.user) {
                        self.user.removeFriend(self.friendProfile)
                    } else {
                        self.user.addFriend(self.friendProfile)
                    }
                }) {
                    Text(self.friendProfile.isAlreadyFriend(of: self.user) ? "Remove Friend 🥺": "Add friend")
                        .foregroundColor(Color.white)
                }
                .frame(width: 100.0, height: 50.0)
                .background(self.friendProfile.isAlreadyFriend(of: self.user) ? Color.red : Color.blue)
                .cornerRadius(50.0)
                .shadow(radius: 1)
                
            }
            .navigationBarTitle(Text(friendProfile.displayName ?? ""))
        }
    }
}

struct FriendProfileView_Previews: PreviewProvider {
    private static var friendProfile: FriendProfileSearchable = FriendProfileSearchable(displayName: "Bill", uid: "")
    static var previews: some View {
        FriendProfileView(friendProfile: friendProfile).environmentObject(UserObservable())
    }
}
