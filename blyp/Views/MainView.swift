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
    @EnvironmentObject var login: LoginStatus

    @State var displayName: String
    @State var loggedOut = false
    var body: some View {
        NavigationView {
            VStack {
                Text(displayName)
                Button("Logout", action: logout).sheet(isPresented: $loggedOut) {
                    LoginView()
                }
            }
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            loggedOut = true
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(displayName: "test-username")
    }
}
