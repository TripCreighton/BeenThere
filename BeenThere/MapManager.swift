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

    let defaults = UserDefaults.standard,
        defaultKeys = DefaultKeys(),
        mapView = MKMapView(),
        utils = Utilities(),
        defaultLocation = CLLocationCoordinate2D(latitude: 34.4293457, longitude: -119.6965677),
        locationManager = CLLocationManager()

    /*      Closures      */
    
    // Unfortunately this is REALLY inefficient but it works for the time being :)
    private var pinList:[MKPointAnnotation]? = [] {
        didSet {
            var tempLat:[Double] = [],
                tempLon:[Double] = []
            
            for pin in pinList! {
                tempLat.append(pin.coordinate.latitude)
                tempLon.append(pin.coordinate.longitude)
            }
            
            defaults.set(tempLat, forKey: defaultKeys.annotationLatitudeList)
            defaults.set(tempLon, forKey: defaultKeys.annotationLongitudeList)
        }
    }
    
    var shouldSavePins:Bool! = false
    
    var dropPinImage:UIImage? = nil {
        didSet {
            
        }
    }
    
    var mapType:MKMapType? = .satelliteFlyover {
        didSet {
            self.mapView.mapType = mapType!
        }
    }
    
    /// Get OR set the current position where the map is viewing:
    var currentPosition:CLLocationCoordinate2D? {
        didSet {
            self.mapView.setRegion( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (currentPosition?.latitude)!, longitude: (currentPosition?.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        }
    }
    
    /// Get OR set whether the user can delete a pin they've placed by tapping on it:
    var deletePinTapped:Bool? = false
    
    /// Get OR set whether the users route should be traced:
    var shouldTraceRoute:Bool? = false
    
    /// Return the current location of the user:
    var currentUserLocation:CLLocationCoordinate2D! {
        return mapView.userLocation.coordinate
    }
    
    /// Sets and gets whether the users location is being shown:
    var showUserLocation:Bool? = false{
        didSet {
            self.mapView.showsUserLocation = showUserLocation!
        }
    }
    
    /// Sets and gets whether the user is being tracked or not:
    var shouldTrackUser:Bool?  = false {
        didSet {
            if shouldTrackUser! {
                self.mapView.userTrackingMode = .follow
                self.mapView.setCenter(currentUserLocation, animated: true)
                return
            }
            self.mapView.userTrackingMode = .none
        }
    }
    
    /// Sets and gets whether the compass is being shown:
    var showCompass:Bool? = false {
        didSet {
            self.mapView.showsCompass = showCompass!
        }
    }
    
    // Ignore please, compiler is a meanie! :)
    private override init() {
        super.init()
    }
    
    convenience init(frame: CGRect, mapType: MKMapType) {
        self.init()
        
        // Setup authorization:
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("[\\(Utilities.getTime())] Location has already been authorized!")
            locationManager.delegate = self
        case .denied:
            print("[\\(Utilities.getTime())] Locaiton has been denied! Possibly notify the user?")
        case.notDetermined:
            print("[\\(Utilities.getTime())] Location has not yet been determined. Requesting now!")
            locationManager.requestWhenInUseAuthorization()
        default:
            print("[\\(Utilities.getTime())] Default.")
            break
        }
        
        // Setup mapview:
        mapView.delegate = self
        mapView.mapType = mapType
        mapView.frame = frame
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Retrieve keys:
        if shouldSavePins, let lats = defaults.array(forKey: defaultKeys.annotationLatitudeList) as! [Double]?, let lons = defaults.array(forKey: defaultKeys.annotationLongitudeList) as! [Double]? {
            
            var tempArr:[MKPointAnnotation]? = []
            for (lat, lon) in zip(lats, lons) {
                let temp = MKPointAnnotation()
                temp.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                tempArr?.append(temp)
            }
            pinList = tempArr
            self.mapView.addAnnotations(pinList!)
        }
        
    }
    
    /// Adds a polyline to the map at a coordinate:
    func addPolyline(_ coord: CLLocationCoordinate2D) {
        let lines = [coord]
        self.mapView.addOverlays([MKPolyline(coordinates: lines, count: lines.count)])
    }
    
    // Drops a pin on the map:
    func dropPin(coord: CLLocationCoordinate2D!, withTitle: String, andDescription: String) {
        let tempAnn = MKPointAnnotation()
        tempAnn.coordinate = coord
        tempAnn.title = withTitle
        tempAnn.subtitle = andDescription
        self.mapView.addAnnotation(tempAnn)
    }
    
    /// Removes a given pin:
    func removePin(view: MKPointAnnotation) {
        self.mapView.removeAnnotation(view)
    }
}

extension MapManager : MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if deletePinTapped!, let pin:MKPointAnnotation = view.annotation as? MKPointAnnotation {
            removePin(view: pin)
        }
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if shouldTraceRoute! {
            addPolyline(userLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.rect(for: MKMapRect(origin: MKMapPointMake(0, 0), size: MKMapSizeMake(40, 40)))
        renderer.strokeColor = UIColor(r: 37, g: 164, b: 254, a: 255)
        renderer.lineWidth = 6.0
        renderer.lineJoin = .round
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView, let img = dropPinImage {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = img
            annotationView.isDraggable = true
        }
        
        return annotationView
    }
}

extension MKMapView {
    func getCoordinates(fromAddress: String, completion: @escaping (CLLocationCoordinate2D) -> ()) {
        var geocoder = CLGeocoder(),
        coords = CLLocationCoordinate2D()
        geocoder.geocodeAddressString(fromAddress) { (placemark, err) in
            if let error = err { return }
            coords = (MKPlacemark(placemark: placemark![0]).location?.coordinate)!
            completion(coords)
        }
    }
}
