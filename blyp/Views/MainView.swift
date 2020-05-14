//
//  MainView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI
import UIKit

/// Homepage of Blyp. Users can look at Blyps from themselves or their friends and create new Blyps or customize their profile.
struct MainView: View {
    @EnvironmentObject var user: UserObservable
    @State private var isBlypPresented: Bool = false
    @State private var selectedBlyp: Blyp?

    var body: some View {
        NavigationView {
            TabView {
                // Personal blyps
                BlypList(isBlypPresented: $isBlypPresented, selectedBlyp: $selectedBlyp, blypsObservable: user.blyps!, selectedBlypList: .personal)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                }

                // Blyps from friends
                BlypList(isBlypPresented: $isBlypPresented, selectedBlyp: $selectedBlyp, blypsObservable: user.blyps!, selectedBlypList: .friends)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                }
            }
            .sheet(isPresented: $isBlypPresented) {
                BlypView(blyp: self.selectedBlyp ?? Blyp(name: "Oops", description: "Something went wrong")).environmentObject(self.user)
            }
            .navigationBarTitle(Text("Blyp"))
            .navigationBarItems(leading: AddBlypButton(), trailing: MoreOptionsButton())
        }.modifier(TableViewLine(is: .hidden))
    }
}

/// Button that triggers opening the "Add Blyp" sheet
struct AddBlypButton: View {
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

/// Button that triggers sheet that slides in from the bottom for user input from the "More" button
struct MoreOptionsButton: View {
    @EnvironmentObject var user: UserObservable
    @State var isManageFriendsPresented = false
    @State private var showingSheet = false

    var body: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "ellipsis.circle.fill").font(.title).accessibility(label: Text("More"))
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("What do you want to do?"), buttons: [
                .default(Text("Manage Friends"), action: {
                    self.isManageFriendsPresented.toggle()
                }),

                .default(Text("Update Username"), action: {
                    self.user.loginState = .signingUp
                }),

                .destructive(Text("Logout"), action: {
                    self.user.logout()
                }),

                .cancel()
            ])
        }
        .sheet(isPresented: $isManageFriendsPresented) {
            FriendManager().environmentObject(self.user)
        }
    }
}

struct BlypList: View {
    @EnvironmentObject var user: UserObservable
    @Binding var isBlypPresented: Bool
    @Binding var selectedBlyp: Blyp?
    @ObservedObject var blypsObservable: BlypsObservable
    var selectedBlypList: SelectedBlypList

    var body: some View {
        // Scrollabel
        List(self.selectedBlypList == .friends ? self.blypsObservable.friends : self.blypsObservable.personal) { blyp in
            VStack(alignment: .center) {
                GeometryReader { innerGeometry in
                    BlypCard(blyp: blyp)
                        .shadow(radius: self.isBlypPressed(blyp) ? 3.0 : 9.0, x: 0, y: 5)
                        // shrinky animation for selected blypcard (same for the shadow above, gives it the look of moving in and out
                        .scaleEffect(self.isBlypPressed(blyp) ? 0.95 : 1.0)
                        .animation(.spring())
                        .accessibility(label: Text("Card"))
                        .onTapGesture {
                            // Open the blyp when its card is tapped
                            self.selectedBlyp = blyp
                            self.isBlypPresented.toggle()
                    }.frame(width: innerGeometry.size.width)
                }
            }
            .frame(height: 260)
        }
    }

    func isBlypPressed(_ blyp: Blyp) -> Bool {
        return selectedBlyp == blyp && isBlypPresented
    }

    enum SelectedBlypList {
        case friends
        case personal
    }
}

struct MainView_Previews: PreviewProvider {
    private static var testBlyps: [Blyp] = [
        Blyp(name: "Test 1 name", description: "Test 1 description"),
        Blyp(name: "Test 2 name", description: "Test 2 description"),
        Blyp(name: "Test 3 name", description: "Test 3 description"),
        Blyp(name: "Test 4 name", description: "Test 4 description")
    ]

    static var previews: some View {
        MainView().environmentObject(UserObservable())
    }
}
