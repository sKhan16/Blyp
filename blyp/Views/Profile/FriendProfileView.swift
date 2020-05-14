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
    var friendProfile: FriendProfile
    
    init(friendProfile: FriendProfile) {
        self.friendProfile = friendProfile
    }
    
    var body: some View {
        VStack {
            Text("Here's some information about \(friendProfile.displayName ?? "")")
            VStack {
                Button(action: {
                    if self.friendProfile.isAlreadyFriend(of: self.user) {
                        self.user.removeFriend(self.friendProfile)
                    } else {
                        self.user.addFriend(self.friendProfile)
                    }
                }) {
                    Text(self.friendProfile.isAlreadyFriend(of: self.user) ? "Remove Friend 🥺" : "Add friend")
                        .foregroundColor(Color.white)
                }
                .padding()
                .frame(minWidth: 100, minHeight: 50.0)
                .background(self.friendProfile.isAlreadyFriend(of: self.user) ? Color.red : Color.blue)
                .cornerRadius(50.0)
                .shadow(radius: 1)
                .padding()
                .animation(.easeInOut)
                Button(action: {
                    if self.friendProfile.isLegacyContact(of: self.user) {
                        self.user.removeLegacyContact()
                    } else {
                        self.user.setLegacyContact(to: self.friendProfile)
                    }
                }) {
                    Text(self.friendProfile.isLegacyContact(of: self.user) ? "Remove Legacy Contact" : "Set as Legacy Contact")
                        .foregroundColor(Color.white)
                }
                .padding()
                .background(self.friendProfile.isLegacyContact(of: self.user) ? Color.red : Color.blue)
                .cornerRadius(50.0)
                .shadow(radius: 1)
                .padding()
                .animation(.easeInOut)
            }
            Spacer()
        }
        .navigationBarTitle(Text(friendProfile.displayName ?? "NAME"))
    }
}


//struct FriendProfileView_Previews: PreviewProvider {
//    private static var friendProfile: FriendProfileSearchable = FriendProfileSearchable(displayName: "Bill", uid: "")
//    static var previews: some View {
//        FriendProfileView(friendProfile: friendProfile).environmentObject(UserObservable())
//    }
//}
