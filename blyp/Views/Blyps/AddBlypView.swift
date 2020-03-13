//
//  AddBlypView.swift
//  blyp
//
//  Created by Shakeel Khan on 3/11/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct AddBlypView: View {
    @EnvironmentObject var user: UserObservable
    @State private var name : String = ""
    @State private var desc: String = ""
    @State private var image: String = ""
    var body: some View {
        VStack {
            Form {
                TextField("Blyp name", text: $name)
                TextField("Description", text: $desc)
                TextField("Image (optional)", text: $image)
            }
            Button(action: {
                // FIXME:
//                self.user.addblyp()
            }) {
                Text("Done")
                    .font(.largeTitle)
            }
        }
    }
}

struct AddBlypView_Previews: PreviewProvider {
    @Binding var blyps: [Blyp]
    static var previews: some View {
        AddBlypView().environmentObject(UserObservable())
    }
}
