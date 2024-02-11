//
//  ViewController.swift
//  MapboxTestv4
//
//  Created by Martin on 2/11/24.
//

import UIKit
import MapboxMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a map view with the default style and options
        let mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the map view to the view hierarchy
        view.addSubview(mapView)
        
        // Set the center coordinates and zoom level of the map
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060) // New York City coordinates
        let cameraOptions = CameraOptions(center: centerCoordinate, zoom: 1.0) // Zoom level changed to 1.0 for the globe
        mapView.mapboxMap.setCamera(to: cameraOptions)
        
        // Set projection to globe
        try? mapView.mapboxMap.setProjection(StyleProjection(name: .globe))
        
        // Add atmosphere
        try? mapView.mapboxMap.setAtmosphere(Atmosphere())
        
        // Add spinning globe behavior
        addSpinningGlobeBehavior(to: mapView)
    }
    
    func addSpinningGlobeBehavior(to mapView: MapView) {
        let spinningGlobeExample = SpinningGlobeExample()
        spinningGlobeExample.mapView = mapView
        spinningGlobeExample.loadViewIfNeeded()
    }
}


