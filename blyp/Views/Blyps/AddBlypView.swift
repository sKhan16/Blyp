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
    
    /// MARK: State items for the image picker button
    @State private var isShowingImagePicker: Bool = false
    @State private var image2: UIImage?
    @State private var image3: Image?
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Button(action: {}) {
                    Text("Close")
                }
                .foregroundColor(.black)
                
                Spacer()
                
                Text("New Blyp")
                    .foregroundColor(.black)
                    .font(.Agenda)
                    .bold()
                    .italic()
                
                Spacer()
                
                Button(action: { self.user.addBlyp(Blyp(name: self.name, description: self.desc, image: "")); self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Done")
                }
                .foregroundColor(.black)
            }
            .padding([.all])
            .background(Color.blypGreen)
            
            NavigationView {
                Form {
                    Section {
                        TextField("Blyp name", text: $name)
                        TextField("Description", text: $desc)
                    }
                    
                    Section {
                        Button("Add an image", action: {self.isShowingImagePicker = true})
                    }
                }
                .navigationBarTitle("New Blyp")
                .navigationBarHidden(true)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$image2)
                }
            }
        }
    }
    
    func loadImage() {
        guard let image2 = image2 else { return }
        image3 = Image(uiImage: image2)
    }
}

struct AddBlypView_Previews: PreviewProvider {
    @Binding var blyps: [Blyp]
    static var previews: some View {
        AddBlypView().environmentObject(UserObservable())
    }
}
