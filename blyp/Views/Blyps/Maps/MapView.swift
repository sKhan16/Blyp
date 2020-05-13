//
//  MapView.swift
//  blyp
//
//  Created by Hayden Hong on 5/12/20.
//  Copyright © 2020 Team Sonar. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var location: MKPointAnnotation?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.delegate = context.coordinator
        guard let location = location else {
            return mapView
        }
        mapView.setAnnotation(to: location)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context _: Context) {
        guard let location = location else {
            return
        }
        view.setAnnotation(to: location)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

extension MKMapView {
    func setAnnotation(to annotation: MKPointAnnotation) {
        removeAnnotations(annotations)
        addAnnotation(annotation)
    }
}
