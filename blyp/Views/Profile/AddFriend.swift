//
//  AddFriend.swift
//  blyp
//
//  Created by Hayden Hong on 3/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import Introspect

struct AddFriend: View {
    @EnvironmentObject var user: UserObservable
    @State private var searchText = ""
    
    private var userSearcher = UserSearcher()
        
    var body: some View {
        VStack {
            AddFriendHeader()
            SearchBar(searchText: $searchText).introspectTextField { textField in
                textField.becomeFirstResponder()
            }
            MatchedUsernameList(searchQuery: $searchText)
        }
    }
}

struct AddFriend_Previews: PreviewProvider {
    static var previews: some View {
        AddFriend()
    }
}

struct AddFriendHeader: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: {
                // TODO: Force close view
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
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
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

