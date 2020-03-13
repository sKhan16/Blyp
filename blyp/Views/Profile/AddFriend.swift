//
//  AddFriend.swift
//  blyp
//
//  Created by Hayden Hong on 3/13/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct AddFriend: View {
    @EnvironmentObject var user: UserObservable

    @State var userName: String = ""
    var body: some View {
        VStack {
            Text("Add a friend:")
            TextField("Friend's username", text: $userName).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {}) {
                Text("Add Friend")
            }
        }
    }
}

struct AddFriend_Previews: PreviewProvider {
    static var previews: some View {
        AddFriend()
    }
}
