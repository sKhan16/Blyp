//
//  ContentView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var login: LoginStatus

    @State var displayName: String?
    
    var body: some View {
        VStack {
            if login.status == .loggedIn {
                MainView(displayName: displayName ?? "Display Name")
            } else if login.status == .signingUp {
                SignUpView()
            } else if login.status == .loggedOut {
                LoginView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}
