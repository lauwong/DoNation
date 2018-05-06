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
    var requestDisplays = [Requests]()
    var ref: DatabaseReference!
    var locationManager: CLLocationManager!
    static var chosenRequest: Requests = Requests(title: "Test", organization: "Test", description: "Test", address: "Test", state: "CA", zip: "94110", /* openFrom: "test", closingAt: "test",*/ requestedByUser: "test", contactEmail: "test", contactPhone: "test", approved: false)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "requests")
        mapView.showsUserLocation = true
        mapView.delegate = self
        ref.observe(.value, with: { snapshot in
            
            var newItems: [Requests] = []
            
            for item in snapshot.children {
                // 4
                var latitude: CLLocationDegrees = 0
                var longitude: CLLocationDegrees = 0
                
                let requestItem = Requests(snapshot: item as! DataSnapshot)
                
                if requestItem.approved {
                    let fullAddress = requestItem.address + ", " + requestItem.state + " " + requestItem.zip
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(fullAddress) { (placemarks, error) in
                        let placemark = placemarks?.first
                        
                        if let lat = placemark?.location?.coordinate.latitude {
                            latitude = lat
                            
                        }
                        
                        if let lon = placemark?.location?.coordinate.longitude {
                            longitude = lon
                        }
                        
                        let annotation = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: requestItem.title, subtitle: requestItem.description)
                        self.mapView.addAnnotation(annotation)
                        
                        // Use your location
                    }
                    
                     newItems.append(requestItem)
                }
            }
            
            self.requestDisplays = newItems
            
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
        mapView.setRegion(region, animated: true)
        //print(region)
        mapView.userTrackingMode = .follow
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "MapPin"
//
//        if annotation is MapPin {
//            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//                annotationView.annotation = annotation
//                return annotationView
//            } else {
//                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView.isEnabled = true
//                annotationView.canShowCallout = true
//
//                let btn = UIButton(type: .detailDisclosure)
//                annotationView.rightCalloutAccessoryView = btn
//                return annotationView
//            }
//        }
//        return nil
//    }
//
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let mapPin = view.annotation as! MapPin
//        let placeName = mapPin.title
//        let placeInfo = mapPin.subtitle
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//    }
    
}

extension NearMeViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? MapPin else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            
            print(mapView.annotations)
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            let rightButton = UIButton(type: .detailDisclosure)
            // rightButton.addTarget(self, action: #selector(NearMeViewController.moreDetails), for: .touchUpInside)
            view.rightCalloutAccessoryView = rightButton
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView,
                          annotationView view: MKAnnotationView,
                          calloutAccessoryControlTapped control: UIControl) {
        
        let clickedAnnotation = view.annotation?.title
        
        if let click = clickedAnnotation, let selectedAnnotation = click {
            ref.observe(.value, with: { snapshot in
                for item in snapshot.children {
                    
                    let requestItem = Requests(snapshot: item as! DataSnapshot)
                    
                    if requestItem.title == selectedAnnotation {
                        print("your request is " + requestItem.title)
                        NearMeViewController.chosenRequest = requestItem
                        print(NearMeViewController.chosenRequest.title)
                        self.performSegue(withIdentifier: "AnnotationDetails", sender: nil)
                    }
                }
                
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnnotationDetails" {
            let request = NearMeViewController.chosenRequest
            print(NearMeViewController.chosenRequest.title)
            
            // Get our expanded view controller
            let requestExpandedVC = segue.destination as! RequestExpandedViewController
            // Pass selected request to our expanded view controller
            requestExpandedVC.selectedRequest = request
        }
    }
    
    @objc func moreDetails() {
        print("More Details Button")
        
//        let viewController:RequestExpandedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestExpandedViewController") as! RequestExpandedViewController
//        viewController.selectedRequest = Requests(title: "Test", organization: "Test", description: "Test", address: "Test", state: "CA", zip: "94110", openFrom: "test", closingAt: "test", requestedByUser: "test", approved: false)
//        self.present(viewController, animated: false, completion: nil)
    }
    
}
