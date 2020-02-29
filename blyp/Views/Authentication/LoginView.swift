//
//  ContentView.swift
//  blyp
//
//  Created by Hayden Hong on 1/31/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

/**
 
 This file is an absolute crime against coding best practices, please never look at it
 
 */

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var login: LoginStatus

    @State private var completedLoginHasDisplayName = false
    @State private var completedLoginNoDisplayName = false
    @State private var displayName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Blyp")
                
                SignInWithAppleToFirebase({ response in
                    if response == .success {
                        Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
                            if let user = user {
                                if let displayName = user.displayName {
                                    self.displayName = displayName
                                    self.completedLoginHasDisplayName = true
                                } else {
                                    self.completedLoginNoDisplayName = true
                                }
                            }
                        }
                    } else if response == .error {
                        // FIXME: ADD BETTER ERROR HANDLING
                    }
                })
                    .frame(height: 50, alignment: .center)
                    .padding(25)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
