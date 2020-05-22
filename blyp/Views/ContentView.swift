//
//  ContentView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import FirebaseAuth
import SwiftUI

/// View structure that shows different views depending on a user's login state
struct ContentView: View {
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var viewRouter: ViewRouter
    @State var displayName: String?

    var body: some View {
        VStack {
            if user.loginState == .loggedIn {
                MainView()
            } else if user.loginState == .signingUp {
                if (viewRouter.currentPage == "OnboardingView") {
                    OnboardingView()
                } else if (viewRouter.currentPage == "SignUpView") {
                    SignUpView()
                }
            } else if user.loginState == .loggedOut {
                LoginView()
            } else {
                LoginView()
            }
        }
    }
}



