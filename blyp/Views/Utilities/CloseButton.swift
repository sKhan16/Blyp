//
//  CloseButton.swift
//  blyp
//
//  Created by Hayden Hong on 5/14/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import SwiftUI

// Struct to close the current Modal
struct CloseButton: View {
    @Binding var presentationMode: PresentationMode
    var buttonText: String = "Close"
    var body: some View {
        Button(action: {
            self.presentationMode.dismiss()
        }) {
            Text("Close")
        }
    }
}
