//
//  FriendProfileView.swift
//  blyp
//
//  Created by Hayden Hong on 4/6/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

/// View for looking at friends' profiles and adding them as a friend, legacy contact, or marking as deceased
struct FriendProfileView: View {
    @EnvironmentObject var user: UserObservable
    var friendProfile: FriendProfile

    var body: some View {
        VStack {

            FriendHeader(for: friendProfile)

            VStack {
                // Add/Remove Friend
                ToggleFriendshipButton(friendProfile: friendProfile)

                // Add/Remove Legacy Contact
                ToggleLegacyContactButton(friendProfile: friendProfile)

                // Mark as deceased
                ToggleDeceasedButton(friendProfile: friendProfile)
            }
            Spacer()
        }
        .navigationBarTitle(Text(friendProfile.displayName ?? "NAME"))
    }
}

 struct FriendProfileView_Previews: PreviewProvider {
    private static var friendProfile: FriendProfile = FriendProfile(uid: "", displayName: "Bill")
    static var previews: some View {
        FriendProfileView(friendProfile: friendProfile).environmentObject(UserObservable())
    }
 }

private struct FriendHeader: View {
    var friendProfile: FriendProfile
    init (for friendProfile: FriendProfile) {
        self.friendProfile = friendProfile
    }
    var body: some View {
        Text("Here's some information about \(friendProfile.displayName ?? "")")
    }
}

private struct FriendProfileButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(50.0)
            .shadow(radius: 1)
            .padding()
            .animation(.easeInOut)
    }
}

struct ToggleFriendshipButton: View {
    @EnvironmentObject var user: UserObservable
    var friendProfile: FriendProfile
    var body: some View {
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
        .modifier(FriendProfileButtonModifier())
    }
}

struct ToggleLegacyContactButton: View {
    @EnvironmentObject var user: UserObservable
    var friendProfile: FriendProfile
    var body: some View {
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
        .background(self.friendProfile.isLegacyContact(of: self.user) ? Color.red : Color.blue).modifier(FriendProfileButtonModifier())
        .modifier(FriendProfileButtonModifier())
    }
}

struct ToggleDeceasedButton: View {
    @EnvironmentObject var user: UserObservable
    var friendProfile: FriendProfile
    var body: some View {
        Button(action: {}) {
            Text("Mark as Deceased").foregroundColor(Color.white)
        }
        .padding()
        .background(Color.red)
        .modifier(FriendProfileButtonModifier())
    }
}
