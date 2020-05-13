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
        VStack(alignment: .leading) {
            if blyp.hasImage {
                BlypImage(blyp: blyp, width: UIScreen.main.bounds.width, contentMode: .fit)
            }
            Text(blyp.name).font(.largeTitle)
            Text(blyp.description)
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .frame(maxHeight: .infinity)
    }
}

struct NewBlypView_Previews: PreviewProvider {
    static var previews: some View {
        BlypView(blyp: Blyp(name: "Test Blyp", description: "Ohhh this is gonna be good"))
    }
}
