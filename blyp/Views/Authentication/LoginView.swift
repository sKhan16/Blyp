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

import AuthenticationServices
import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var user: UserObservable
    
    var body: some View {
        VStack {
            Text("Welcome to Blyp")
            #if DEBUG
            Button("DEVELOPER LOGIN", action: {
                self.user.developerLogin()
            })
                .frame(height: 50, alignment: .center)
                .padding(25)
                .font(.title)
                .accentColor(.red)
                .background(Blur(style: .systemMaterialDark))
            #else
            SignInWithAppleToFirebase { response in
                if response == .success {
                    Auth.auth().addStateDidChangeListener { (_: Auth, user: User?) in
                        if let user = user {
                            self.user.completeLogin(user: user)
                        }
                    }
                } else if response == .error {
                    // FIXME: ADD BETTER ERROR HANDLING
                }
            }
            .frame(height: 50, alignment: .center)
            .cornerRadius(6.0) // This crops off the weird white corners that are visible on the gradient background
                .opacity(0.9)
            .padding(25)
            #endif
        }
        .edgesIgnoringSafeArea(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(PastelViewRepresentable(colors: [UIColor(named: "BlypOrange")!,UIColor(named: "BlypYellow")!, UIColor(named: "BlypGreen")!], startPastelPoint: .top, endPastelPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserObservable())
    }
}
