//
//  MapManager.swift
//  BeenThere
//
//  Created by Trip Creighton on 2/10/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import Foundation
import MapKit

class MapManager : NSObject {
    
    var mapView:MKMapView?
    var mapType:MKMapType?
    var currentPosition:CLLocationCoordinate2D? {
        didSet {
            //TODO
        }
    }
    
    
    private override init() {
        super.init()
    }
    
    convenience init(mapType: MKMapType) {
        self.init()
        mapView?.delegate = self
    }
    
    // Configures the mapview and anything else the map view needs.
    func configure() {
        mapView?.mapType = mapType ?? .hybridFlyover
    }
    
    // Drops a pin to the screen.
    func dropPin(coord: CLLocationCoordinate2D!) {
        
    }
}

extension MapManager : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.reuseIdentifier ?? "ERROR")
    }
}
