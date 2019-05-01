//
//  PlaceMark.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import MapKit

protocol PlaceMarkProtocol: class {
    func remove(mark: PlaceMark)
}

class PlaceMark: NSObject, MKAnnotation {
    private struct Constants {
        static let year = 1990
    }
    
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    let lifeTime: Int
    
    weak var delegate: PlaceMarkProtocol?
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D, begin: Int) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        lifeTime = begin - Constants.year
        
        super.init()
    }
    
    convenience init?(place: Place) {
        guard let coordiantesStr = place.coordinates,
            let latitude = Double(coordiantesStr.latitude),
            let longitude = Double(coordiantesStr.longitude),
            let title = place.name,
            let begin = place.lifeSpan?.begin,
            let beginInt = Int(String(begin.prefix(4))) else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(title: title, locationName: place.address, coordinate: coordinate, begin: beginInt)
    }
    
    func startLife() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(lifeTime), execute: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.remove(mark: strongSelf)
        })
    }
    
    var subtitle: String? {
        return locationName
    }
}
