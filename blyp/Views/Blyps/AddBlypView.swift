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
    @State private var imageData: UIImage?
    @State var imageView: Image?
    var body: some View {
        VStack {
            NewBlypHeader(saveBlyp: saveBlyp)
            NavigationView {
                Form {
                    Section {
                        TextField("Blyp name", text: $name)
                        TextField("Description", text: $desc)
                    }
                    
                    Section {
                        Button(imageView == nil ? "Add an image" : "Select a different image", action: {self.isShowingImagePicker = true})
                        
                        if (imageView != nil) {
                            SelectedImageView(image: imageView!)
                        }
                    }
                }
                .navigationBarTitle("New Blyp")
                .navigationBarHidden(true)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$imageData)
                }
            }
        }
    }
    
    /// Loads image data from the selected image (or not)
    func loadImage() {
        guard let imageData = imageData else { return }
        imageView = Image(uiImage: imageData)
    }
    
    /// Saves blyp and dismiss view
    func saveBlyp() {
        let blyp = Blyp(name: self.name, description: self.desc, imageData: self.imageData?.jpegData(compressionQuality: 0.5))
        user.blyps?.addBlyp(blyp)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddBlypView_Previews: PreviewProvider {
    @Binding var blyps: [Blyp]
    static var previews: some View {
        Group {
            AddBlypView().environmentObject(UserObservable()).previewDisplayName("Standard")
            AddBlypView(imageView: Image("PreviewSelectedImageLandscape")).environmentObject(UserObservable()).previewDisplayName("With landscape image")
                        AddBlypView(imageView: Image("PreviewSelectedImagePortrait")).environmentObject(UserObservable()).previewDisplayName("With portrait image")
            AddBlypView().environmentObject(UserObservable()).colorScheme(.dark).previewDisplayName("Dark Mode")
        }
    }
}

struct NewBlypHeader: View {
    var saveBlyp: () -> Void
    var body: some View {
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
            
            Button(action: saveBlyp) {
                Text("Done")
            }
            .foregroundColor(.black)
        }
        .padding([.all])
        .background(Color.blypGreen)
    }
}

struct SelectedImageView: View {
    let image: Image
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
    }
}
