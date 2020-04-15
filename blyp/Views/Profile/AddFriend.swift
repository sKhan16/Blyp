//
//  AddFriend.swift
//  blyp
//
//  Created by Hayden Hong on 3/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import Introspect
import SwiftUI
import Combine

struct AddFriend: View {
    @EnvironmentObject var user: UserObservable
    @Binding var isPresented: Bool
    
    @State private var searchText = ""
    @State private var userSearcher = UserSearcher()
    
    var body: some View {
        NavigationView {
            VStack {
                AddFriendHeader(isPresented: $isPresented)
                SearchBar(userSearcher: userSearcher)
                MatchedUsernameList(userSearcher: userSearcher)
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
    @Binding var isPresented: Bool
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: {
                self.isPresented = false
            }) {
                Text("Close")
            }
            Spacer()
            Text("Add Friend")
            Spacer()
            Button(action: {
                // TODO: Open help
            }) {
                Text("Help")
            }
        }.padding([.top, .leading, .trailing]).frame(minHeight: 32)
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
