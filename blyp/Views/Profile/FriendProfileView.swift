//
//  FriendProfileView.swift
//  blyp
//
//  Created by Hayden Hong on 4/6/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct FriendProfileView: View {
    var name: String
    var body: some View {
        NavigationView {
            VStack {
                Text("Here's some information about \(name):")
                Spacer()
                Button(action: {
                    print("TODO: ADD FRIEND")
                }) {
                    Text("Add friend")
                        .foregroundColor(Color.white)
                }
                .frame(width: 100.0, height: 50.0)
                .background(Color.blue)
                .cornerRadius(50.0)
                .shadow(radius: 1)
            }
            .navigationBarTitle(Text(name))
        }
    }
}

struct FriendProfileView_Previews: PreviewProvider {
    private static var friendName: String = "John Doe"
    static var previews: some View {
        FriendProfileView(name: friendName)
    }
}
