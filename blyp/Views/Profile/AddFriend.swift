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

struct ManageFriends: View {
    @EnvironmentObject var user: UserObservable
    @ObservedObject private var userSearcher = UserSearcher()
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(userSearcher: userSearcher)
                if userSearcher.searchQuery != "" {
                    FriendsList(searchHits: userSearcher.displayNameAlgolia.hits)
                } else {
                    FriendsList(friends: user.friends)
                }
            }
            .navigationBarTitle(Text(userSearcher.searchQuery == "" ? "My Friends" : "Add Friend").bold().italic(), displayMode: .inline)
            .navigationBarItems(leading: CloseButton())
        }
    }
}

private struct CloseButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Close")
        }
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

struct AddFriend_Previews: PreviewProvider {
    static var previews: some View {
        ManageFriends().environmentObject(UserObservable())
    }
}
