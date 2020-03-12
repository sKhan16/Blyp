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
    @Binding var blyps: [Blyp]
    @State private var name : String = ""
    @State private var desc: String = ""
    @State private var image: String = ""
    var body: some View {
        
        VStack {
            Form {
                TextField("Enter Blyp name", text: $name)
                TextField("Description", text: $desc)
                TextField("Image (optional)", text: $image)
            }
            Button(action: {
                self.blyps.append(Blyp(name: self.name, image: self.image, description: self.desc))
            }) {
                Text("Done")
                    .font(.largeTitle)
            }
        }
           // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
}
}

struct AddBlypView_Previews: PreviewProvider {
    @Binding var blyps: [Blyp]
    static var previews: some View {
      //  PreviewWrapper()
    //}
    
    //Need this wrapper for live previews to work properly
    //If another way is found please replace this lol.
    //struct PreviewWrapper: View {
        //@State(initialValue: [Blyp(name: "ah", description: "ahhh")]) var blyps: [Blyp]
        
        //var body: some View {
        AddBlypView(blyps: .constant([Blyp(name: "test", description: "For previews")]))
        }
    //}
}
