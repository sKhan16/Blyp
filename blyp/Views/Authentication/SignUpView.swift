//
//  SignUpView.swift
//  blyp
//
//  Created by Hayden Hong on 2/28/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var login: LoginStatus

    var body: some View {
        Text("Create an account:")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
