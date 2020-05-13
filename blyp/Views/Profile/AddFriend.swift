//
//  AddFriend.swift
//  blyp
//
//  Created by Hayden Hong on 3/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Combine
import Introspect
import SwiftUI

struct AddFriend: View {
    @EnvironmentObject var user: UserObservable
    @Binding var isPresented: Bool
    @State private var userSearcher = UserSearcher()

    var body: some View {
        NavigationView {
            VStack {
                AddFriendHeader(userSearcher: userSearcher)
                SearchBar(userSearcher: userSearcher)
                if (userSearcher.searchQuery != "") {
                    MatchedUsernameList(userSearcher: userSearcher)
                } else {
                    FriendsList()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct AddFriend_Previews: PreviewProvider {
    @State private static var isPresented = true
    static var previews: some View {
        AddFriend(isPresented: $isPresented)
    }
}

struct AddFriendHeader: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userSearcher: UserSearcher
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
                Spacer()
                Text(userSearcher.searchQuery == "" ? "My Friends" : "Add Friend")
                Spacer()
                Button(action: {
                    // TODO: Open help
                }) {
                    Text("Help")
                }
            }
            Divider()
        }
        .padding([.top, .leading, .trailing])
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
