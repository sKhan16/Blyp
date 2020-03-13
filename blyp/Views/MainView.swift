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
        VStack {
            NavigationView {
                List(user.blyps) { blyp in
                    NavigationLink(destination: BlypView(blyp: blyp)) {
                        Text(blyp.name)
                    }
                }
                .navigationBarTitle("\(user.displayName)'s Blyps")
                .navigationBarItems(leading: AddBlypButton(),
                    trailing: LogoutButton())
            }
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

struct AddBlypButton: View {
    var body: some View {
        NavigationLink(destination: AddBlypView()) {
            Text("Add blyp")
        }.navigationBarTitle("Add blyp")
    }
}
