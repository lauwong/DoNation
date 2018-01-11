//
//  NearMeViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 12/22/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class NearMeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let ref = Database.database().reference(withPath: "requests")
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        ref.observe(.value, with: { snapshot in
            var locations: [CLLocationDegrees] = []
            var allLocations: [[CLLocationDegrees]] = []
            for item in snapshot.children {
                // 4
                let requestItem = Requests(snapshot: item as! DataSnapshot)
                if requestItem.approved {
                    let fullAddress = requestItem.address + ", " + requestItem.state + " " + requestItem.zip
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(fullAddress) { (placemarks, error) in
                        let placemark = placemarks?.first
                        locations = []
                        
                        if let lat = placemark?.location?.coordinate.latitude {
                            locations.append(lat)
                            
                        }
                        
                        if let lon = placemark?.location?.coordinate.longitude {
                            locations.append(lon)
                        }
                        
                        allLocations.append(locations)
                        
                        print(locations)
                        for array in allLocations {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: array[0], longitude: array[1])
                            self.mapView.addAnnotation(annotation)
                        }
                        
                        // Use your location
                    }
                }
                
            }
        })
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
}
