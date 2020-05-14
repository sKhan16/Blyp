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
    @Binding var title: String
    @Binding var subtitle: String
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var location: MKPointAnnotation?

    private var previousLocation: MKPointAnnotation?

    init(title: Binding<String>, subtitle: Binding<String>, centerCoordinate: Binding<CLLocationCoordinate2D>, location: Binding<MKPointAnnotation?>) {
        _title = title
        _subtitle = subtitle
        _centerCoordinate = centerCoordinate
        _location = location
        // Save the previous location just in case
        previousLocation = location.wrappedValue
    }

    var body: some View {
        NavigationView {
            ZStack {
                MapView(centerCoordinate: $centerCoordinate, location: $location, title: $title, subtitle: $subtitle).edgesIgnoringSafeArea(.all)
                CenterDotView()
                Footer(action: setLocation)
            }
            .navigationBarTitle("Blyp Location", displayMode: .inline)
            .navigationBarItems(leading: CloseMapButton(presentationMode: presentationMode, location: $location), trailing: DoneButton(presentationMode: presentationMode))
        }
    }

    func setLocation() {
        let newLocation = MKPointAnnotation()
        newLocation.coordinate = centerCoordinate
        location = newLocation
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

// Slightly different CloseButton that restores previous location data
private struct CloseMapButton: View {
    @Binding var presentationMode: PresentationMode
    @Binding var location: MKPointAnnotation?
    var previousLocation: MKPointAnnotation?
    var body: some View {
        Button(action: {
            // Override new location with previous location then close
            self.location = self.previousLocation
            self.presentationMode.dismiss()
        }) {
            Text("Close")
        }
    }
}

private struct DoneButton: View {
    @Binding var presentationMode: PresentationMode
    var body: some View {
        Button(action: {
            self.presentationMode.dismiss()
        }) {
            Text("Done")
        }
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

struct AddMapLocationView_Previews: PreviewProvider {
    @State static var seattle = CLLocationCoordinate2D()
    @State static var spaceNeedle: MKPointAnnotation? = MKPointAnnotation()
    @State static var title: String = "Space Needle"
    @State static var subtitle: String = "Built in 1962"
    static var previews: some View {
        AddMapLocationView(title: $title, subtitle: $subtitle, centerCoordinate: $seattle, location: $spaceNeedle)
    }
}
