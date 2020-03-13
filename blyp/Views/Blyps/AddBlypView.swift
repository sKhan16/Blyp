//
//  AddBlypView.swift
//  blyp
//
//  Created by Shakeel Khan on 3/11/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct AddBlypView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserObservable
    @State private var name: String = ""
    @State private var desc: String = ""
    @State private var image: String = ""
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Button(action: {}) {
                    Text("Close")
                }
                Spacer()
                Text("Add new Blyp")
                Spacer()
                Button(action: {self.user.addBlyp(Blyp(name: self.name, description: self.desc, image: self.image)); self.presentationMode.wrappedValue.dismiss()}) {
                    Text("Done")
                }
                
            }.padding([.top, .leading, .trailing]).frame(minHeight: 32)
            Form {
                TextField("Blyp name", text: $name)
                TextField("Description", text: $desc)
                TextField("Image (optional)", text: $image)
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
