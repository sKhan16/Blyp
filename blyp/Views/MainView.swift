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
    @EnvironmentObject var user: UserObservable
    var body: some View {
        VStack {
            Text(user.displayName)
            
            Button(action: {self.user.logout()}) {
                Text("Logout")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
