//
//  PlaceMark.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import MapKit

class PlaceMark: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    convenience init?(place: Place) {
        guard let coordiantesStr = place.coordinates,
            let latitude = Double(coordiantesStr.latitude),
            let longitude = Double(coordiantesStr.longitude),
            let title = place.name else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(title: title, locationName: place.address, coordinate: coordinate)
    }
    
    var subtitle: String? {
        return locationName
    }
}
