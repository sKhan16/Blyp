//
//  AddBlypView.swift
//  blyp
//
//  Created by Shakeel Khan on 3/11/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import MapKit
import SwiftLocation
import SwiftUI

struct AddBlypView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserObservable

    // MARK: State items for the required Blyp descriptors

    @State private var name: String = ""
    @State private var desc: String = ""

    // MARK: State items for the image picker button

    @State private var isShowingImagePicker: Bool = false
    @State private var imageData: UIImage?
    @State var imageView: Image?

    // MARK: State items for map view

    @State private var isShowingMapView: Bool = false
    @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 122.3493, longitude: 47.6205) // space needle ❤️
    @State private var location: MKPointAnnotation?

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: HStack {
                        Text("General")
                        Text("Required")
                            .foregroundColor(Color.red)
                    }) {
                        MainSection(name: $name, description: $desc)
                    }

                    Section(header: Text("Media")) {
                        MediaSection(isShowingImagePicker: $isShowingImagePicker, imageView: $imageView, imageData: $imageData, loadImage: loadImage)
                    }

                    Section(header: Text("Location")) {
                        LocationSection(name: $name, description: $desc, location: $location, centerCoordinate: $centerCoordinate, isShowingMapView: $isShowingMapView)
                    }
                }
                .navigationBarTitle("New Blyp")
                .navigationBarItems(leading: CloseButton(presentationMode: self.presentationMode), trailing: PostButton(saveBlyp: saveBlyp, isSubmittable: self.isSubmittable()))
            }
        }.modifier(TableViewLine(is: .shown))
    }

    /// Loads image data from the selected image (or not)
    func loadImage() {
        guard let imageData = imageData else { return }
        imageView = Image(uiImage: imageData.fixedOrientation()!)
    }

    func isSubmittable() -> Bool {
        name != "" && desc != ""
    }

    /// Saves blyp and dismiss view
    func saveBlyp() {
        let latitude: Double? = location?.coordinate.latitude
        let longitude: Double? = location?.coordinate.longitude
        let blyp = Blyp(name: name, description: desc, longitude: longitude, latitude: latitude, image: imageData)
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

struct SelectedImageView: View {
    let image: Image
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: ContentMode.fit)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 400, alignment: .center)
    }
}

struct PostButton: View {
    var saveBlyp: () -> Void
    var isSubmittable: Bool
    var body: some View {
        Button(action: saveBlyp) {
            Text("Post")
        }
        .disabled(!isSubmittable)
    }
}

private struct CloseButton: View {
    @Binding var presentationMode: PresentationMode
    var body: some View {
        Button(action: {
            self.presentationMode.dismiss()
        }) {
            Text("Close")
        }
    }
}

struct MainSection: View {
    @Binding var name: String
    @Binding var description: String
    var body: some View {
        Group {
            TextField("Blyp name", text: $name)
            TextField("Description", text: $description)
        }
    }
}

struct MediaSection: View {
    @Binding var isShowingImagePicker: Bool
    @Binding var imageView: Image?
    @Binding var imageData: UIImage?
    var loadImage: () -> Void
    var body: some View {
        Group {
            Button(imageView == nil ? "Add an image" : "Select a different image", action: { self.isShowingImagePicker = true }).sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$imageData)
            }
            if imageView != nil {
                SelectedImageView(image: imageView!)
            }
        }
    }
}

struct LocationSection: View {
    @Binding var name: String
    @Binding var description: String
    @Binding var location: MKPointAnnotation?
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var isShowingMapView: Bool
    var body: some View {
        Group {
            Button(location == nil ? "Add a location" : "Select a different location", action: {
                // Try to get user's location if there isn't already a set location
                if self.location == nil {
                    LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city) { result in
                        switch result {
                        case let .failure(error):
                            debugPrint("Received location error: \(error), this is fine")
                            self.isShowingMapView.toggle()
                        case let .success(location):
                            debugPrint("Location received: \(location)")
                            self.centerCoordinate = location.coordinate
                        }
                        self.isShowingMapView.toggle()
                    }
                } else {
                    self.isShowingMapView.toggle()
                }
            }).sheet(isPresented: $isShowingMapView) {
                AddMapLocationView(title: self.$name, subtitle: self.$description, centerCoordinate: self.$centerCoordinate, location: self.$location)
            }

            if location != nil {
                UpdatingMap(location: $location, title: $name, subtitle: $description)
                    .frame(height: 300)
                    .edgesIgnoringSafeArea(.horizontal)
            }
        }
    }
}
