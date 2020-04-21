//
//  MainView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var user: UserObservable
    init() {
    }
    var body: some View {
        NavigationView {
            List(user.blyps) { blyp in
                NavigationLink(destination: BlypView(blyp: blyp)) {
                    Text(blyp.name)
                }
            }
            .navigationBarTitle("Blyp", displayMode: .inline)
            .navigationBarItems(leading: AddBlypViewButton().environmentObject(user),
                                trailing: MainViewActionSheet().environmentObject(user))
        }
    }
}

struct AddBlypViewButton: View {
    @EnvironmentObject var user: UserObservable
    @State var editingBlyp = false
    var body: some View {
        Button(action: {
            self.editingBlyp.toggle()
        }) {
            Image(systemName: "plus").font(.title).accessibility(label: Text("Add Blyp"))
        }
        .sheet(isPresented: $editingBlyp) {
            AddBlypView().environmentObject(self.user)
        }
    }
}

struct MainViewActionSheet: View {
    @EnvironmentObject var user: UserObservable
    @State var addingFriend = false
    @State private var showingSheet = false
    
    var body: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "ellipsis.circle.fill").font(.title).accessibility(label: Text("More"))
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("What do you want to do?"), buttons: [
                .default(Text("Add Friends"), action: {
                    self.addingFriend.toggle()
                }),
                
                .default(Text("Update Username"), action: {
                    self.user.loginState = .signingUp
                }),
                
                .destructive(Text("Logout"), action: {
                    self.user.logout()
                }),
                
                .cancel(),
            ])
        }
        .sheet(isPresented: $addingFriend) {
            AddFriend(isPresented: self.$addingFriend).environmentObject(self.user)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserObservable())
    }
}
