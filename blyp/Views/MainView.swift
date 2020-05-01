//
//  MainView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import UIKit
struct MainView: View {
    @EnvironmentObject var user: UserObservable
    
    var blyps: [Blyp]
    
    @State private var isBlypPresented: Bool = false
    @State private var selectedBlyp: Blyp? = nil
    
    init(blyps: [Blyp]) {
        // This is required to not show the ugly lines between the cards
        UITableView.appearance().separatorColor = .clear
        self.blyps = blyps
    }
    
    var body: some View {
        NavigationView {
            List(blyps) { blyp in
                BlypCard(blyp: blyp)
                    .padding(.vertical, 4).onTapGesture {
                        // TODO: Also add shrinky animation?
                        self.selectedBlyp = blyp
                        self.isBlypPresented.toggle()
                }.shadow(radius: 9.0, x: 0, y: 5)
            }
            .sheet(isPresented: $isBlypPresented) {
                BlypView(blyp: self.selectedBlyp ?? Blyp(name: "Oops", description: "Something went wrong"))
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
    static private var testBlyps: [Blyp] = [
        Blyp(name: "Test 1 name", description: "Test 1 description"),
        Blyp(name: "Test 2 name", description: "Test 2 description"),
        Blyp(name: "Test 3 name", description: "Test 3 description"),
        Blyp(name: "Test 4 name", description: "Test 4 description")
    ]
    static var previews: some View {
        MainView(blyps: testBlyps).environmentObject(UserObservable())
    }
}
