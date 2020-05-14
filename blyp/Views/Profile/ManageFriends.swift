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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserObservable
    @State private var isShowingAddFriends: Bool = false
    
    var body: some View {
        NavigationView {
            FriendsList(friends: user.friends)
                .navigationBarTitle("Friends")
                .navigationBarItems(leading: CloseButton(presentationMode: presentationMode), trailing: AddFriendsButton(isShowingAddFriends: $isShowingAddFriends))
        }.sheet(isPresented: $isShowingAddFriends) {
            AddFriends(userSearcher: UserSearcher()).environmentObject(self.user)
        }.modifier(TableViewLine(is: .shown))
    }
}

private struct AddFriendsButton: View {
    @Binding var isShowingAddFriends: Bool
    var body: some View {
        Button(action: {
            self.isShowingAddFriends.toggle()
        }) {
            Text("Add Friends")
        }
    }
}

private struct CloseButton: View {
    @Binding var presentationMode: PresentationMode
    var body: some View {
        Button(action: {
            self.presentationMode.dismiss()
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
