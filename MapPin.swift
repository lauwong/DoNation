//
//  MapAnnotations.swift
//  DoNation
//
//  Created by Lauren Wong on 1/20/18.
//  Copyright © 2018 The Nueva Quest. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
