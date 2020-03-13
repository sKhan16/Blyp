//
//  NewBlypView.swift
//  blyp
//
//  Created by Hayden Hong on 3/3/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

struct BlypView: View {
    @State var blyp: Blyp
    var body: some View {
        VStack {
            NavigationLink(destination: Text("TODO")) {
                Text("Go visit it!")
            }
            .navigationBarTitle(self.blyp.name)
        }
    }
}

struct NewBlypView_Previews: PreviewProvider {
    static var previews: some View {
        BlypView(blyp: Blyp(name: "Test Blyp", description: "Ohhh this is gonna be good"))
    }
}
