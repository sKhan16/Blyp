//
//  MainView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject var user: UserObservable
    var body: some View {
        NavigationView {
            List(0 ..< 20) { item in
                NavigationLink(destination: BlypView(blyp: Blyp(name: "Item #\(item + 1)", description: "This is just a test element"))) {
                    Text("This will be Blyp #\(item + 1)")
                }
            }
            .navigationBarTitle("\(user.displayName)'s Blyps")
            .navigationBarItems(trailing: LogoutButton())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserObservable())
    }
}

struct LogoutButton: View {
    @EnvironmentObject var user: UserObservable
    var body: some View {
        Button("Logout", action: {self.user.logout()})
    }
}
