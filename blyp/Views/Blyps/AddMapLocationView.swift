//
//  AddMapLocationView.swift
//  blyp
//
//  Created by Hayden Hong on 5/12/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import MapKit
import SwiftLocation
import SwiftUI

struct AddMapLocationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: String
    var subtitle: String
    @Binding var centerCoordinate: CLLocationCoordinate2D //  CLLocationCoordinate2D()
    @State private var location: MKPointAnnotation = MKPointAnnotation()

    init(title: String, subtitle: String, centerCoordinate: Binding<CLLocationCoordinate2D>) {
        self.title = title
        self.subtitle = subtitle
        _centerCoordinate = centerCoordinate
    }

    var body: some View {
        VStack {
            ZStack {
                MapView(centerCoordinate: $centerCoordinate, location: $location).edgesIgnoringSafeArea(.all)
                CenterDotView()
                Header(saveLocation: saveLocation)
                Footer(action: setLocation)
            }
        }
    }

    func setLocation() {
        let newLocation = MKPointAnnotation()
        newLocation.coordinate = centerCoordinate
        newLocation.title = title
        newLocation.subtitle = subtitle
        location = newLocation
    }

    func saveLocation() {
        presentationMode.wrappedValue.dismiss()
    }
}

private struct CenterDotView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .fill(Color.blue)
                    .opacity(0.6)
                    .frame(width: 16, height: 16)
                Spacer()
            }
            Spacer()
        }
    }
}

private struct SetLocationButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: self.action) {
            Text("Set Location")
                .padding()
                .contentShape(Rectangle())
        }

        .background(Blur(style: .systemMaterial))
        .cornerRadius(40)
    }
}

private struct Footer: View {
    var action: () -> Void
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                SetLocationButton(action: action)
                Spacer()
            }
        }
    }
}

private struct Header: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var saveLocation: () -> Void
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Text("Close")
                }.padding()
                Spacer()
                Text("Blyp Location")
                Spacer()
                Button(action: saveLocation) {
                    Text("Done")
                }.padding()
            }.background(Blur(style: .systemMaterial))
            Spacer()
        }
    }
}

struct AddMapLocationView_Previews: PreviewProvider {
    @State static var spaceNeedle = CLLocationCoordinate2D()
    static var previews: some View {
        AddMapLocationView(title: "Title", subtitle: "Subtitle", centerCoordinate: $spaceNeedle)
    }
}
