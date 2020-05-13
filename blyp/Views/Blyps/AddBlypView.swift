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
    @State private var location: MKPointAnnotation? = nil
    
    init(imageView: Image?) {
        self.init()
        self.imageView = imageView
    }
    
    init() {
        UITableView.appearance().separatorColor = nil
    }
    
    var body: some View {
        VStack {
            NewBlypHeader(presentationMode: presentationMode, saveBlyp: saveBlyp, isSubmittable: !(name == "" || desc == ""))
                .padding(.bottom, -12.0)
            NavigationView {
                Form {
                    Section(header: HStack {
                        Text("General")
                        Text("Required")
                            .foregroundColor(Color.red)
                    }) {
                        TextField("Blyp name", text: $name)
                        TextField("Description", text: $desc)
                    }
                    
                    Section(header: Text("Media")) {
                        Button(imageView == nil ? "Add an image" : "Select a different image", action: { self.isShowingImagePicker.toggle() })
                        if imageView != nil {
                            SelectedImageView(image: imageView!)
                        }
                    }
                    
                    Section(header: Text("Location")) {
                        Button(location == nil ? "Add a location" : "Select a different location", action: {
                            // Try to get user's location if there isn't already a set location
                            if (self.location == nil) {
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
                        })
                        if location != nil {
                            UpdatingMap(location: $location, title: $name, subtitle: $desc)
                                .frame(height: 300)
                                .edgesIgnoringSafeArea(.horizontal)
                        }
                    }
                }
                .navigationBarTitle("New Blyp")
                .navigationBarHidden(true)
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$imageData)
                }
                .sheet(isPresented: $isShowingMapView) {
                    AddMapLocationView(title: self.$name, subtitle: self.$desc, centerCoordinate: self.$centerCoordinate, location: self.$location)
                }
            }
        }
    }
    
    /// Loads image data from the selected image (or not)
    func loadImage() {
        guard let imageData = imageData else { return }
        imageView = Image(uiImage: imageData.fixedOrientation()!)
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

struct NewBlypHeader: View {
    @Binding var presentationMode: PresentationMode
    var saveBlyp: () -> Void
    var isSubmittable: Bool
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: { self.presentationMode.dismiss() }) {
                Text("Close")
            }
            .foregroundColor(.black)
            
            Spacer()
            
            Text("New Blyp")
                .foregroundColor(.black)
                //                .font(.Agenda)
                .bold()
                .italic()
            
            Spacer()
            
            Button(action: saveBlyp) {
                Text("Done")
            }
            .foregroundColor(isSubmittable ? .black : .gray)
            .disabled(!isSubmittable)
        }
        .padding()
        .background(Color.blypGreen)
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

/// For some reason this is required for some HEIC images. Beats me. https://gist.github.com/schickling/b5d86cb070130f80bb40
extension UIImage {
    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
        }
        
        ctx.concatenate(transform)
    
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
