//
//  SignUpView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import FirebaseAuth
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var user: UserObservable
    @State var userName: String = "" // Initialized with empty string, this is intended

    var body: some View {
        VStack {
            Text("Create an account:")
            TextField("Username", text: $userName).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: { self.user.changeDisplayName(displayName: self.userName) }) {
                Text("Create")
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(UserObservable())
    }
}
