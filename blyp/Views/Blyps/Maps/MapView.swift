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
    @Binding var title: String
    @Binding var subtitle: String
    
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
        location.title = title
        location.subtitle = subtitle
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

struct UpdatingMap: UIViewRepresentable {
    @Binding var location: MKPointAnnotation?
    @Binding var title: String
    @Binding var subtitle: String
    var isScrollable: Bool = false
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        // We don't set isUserInteractionEnabled becuase we want them to open the annotation lol
        mapView.isScrollEnabled = isScrollable
        mapView.isPitchEnabled = isScrollable
        mapView.isZoomEnabled = isScrollable
        mapView.isScrollEnabled = isScrollable
        
        zoomToLocation(of: location, on: mapView)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context _: Context) {
        zoomToLocation(of: location, on: view)
    }
    
    private func zoomToLocation(of location: MKPointAnnotation?, on mapView: MKMapView) {
        guard let location = location else {
            print("No location available for StaticMapView... what gives?")
            return
        }
        location.title = title
        location.subtitle = subtitle
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.setAnnotation(to: location)
    }
}

struct StaticMap: UIViewRepresentable {
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    var isScrollable: Bool = false
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        // We don't set isUserInteractionEnabled becuase we want them to open the annotation lol
        mapView.isScrollEnabled = isScrollable
        mapView.isPitchEnabled = isScrollable
        mapView.isZoomEnabled = isScrollable
        mapView.isScrollEnabled = isScrollable
        let location = MKPointAnnotation()
        location.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        zoomToLocation(of: location, on: mapView)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context _: Context) {}
    
    private func zoomToLocation(of location: MKPointAnnotation, on mapView: MKMapView) {
        location.title = title
        location.subtitle = subtitle
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        mapView.setAnnotation(to: location)
    }
}

extension MKMapView {
    func setAnnotation(to annotation: MKPointAnnotation) {
        // Only update it if we have to, this fixes flickering
        if (self.annotations.contains { compare in
            compare.title == annotation.title
                && annotation.subtitle == annotation.subtitle
                && compare.coordinate.latitude == annotation.coordinate.latitude
                && compare.coordinate.longitude == annotation.coordinate.longitude
        }) {return}
        removeAnnotations(annotations)
        addAnnotation(annotation)
    }
}
