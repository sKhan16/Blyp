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
    @EnvironmentObject var user: UserObservable
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Blyp")
                #if DEBUG
                Button("DEVELOPER LOGIN", action: {
                    self.user.developerLogin()
                })
                    .frame(height: 50, alignment: .center)
                    .padding(25)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .accentColor(.red)
                #else
                SignInWithAppleToFirebase({ response in
                    if response == .success {
                        Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in
                            if let user = user {
                                self.user.completeLogin(user: user)
                            }
                        }
                    } else if response == .error {
                        // FIXME: ADD BETTER ERROR HANDLING
                    }
                })
                    .frame(height: 50, alignment: .center)
                    .padding(25)
                #endif
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserObservable())
    }
}
