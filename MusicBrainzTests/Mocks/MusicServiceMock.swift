//
//  MusicServiceProtocol.swift
//  MusicBrainzTests
//
//  Created by Piotr Furmanski on 01/05/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation
@testable import MusicBrainz

enum CustomError: Error {
    case someError
}

class MusicServiceMock: MusicServiceProtocol {
    func loadData(for place: String, limit: Int, offset: Int, completion: @escaping (PlaceResponse?, Error?) -> ()) {
        let places = [Place(type: "stadium", name: "Warszawa 1", address: "adres1", coordinates: Coordinates(latitude: "10", longitude: "10"), lifeSpan: LifeSpan(begin: "1991", end: nil, ended: nil)),
                      Place(type: "stadium", name: "Warszawa 2", address: "adres2", coordinates: Coordinates(latitude: "20", longitude: "20"), lifeSpan: LifeSpan(begin: "1989", end: nil, ended: nil)),
                      Place(type: "stadium", name: "Warszawa 3", address: "adres3", coordinates: Coordinates(latitude: "30", longitude: "30"), lifeSpan: LifeSpan(begin: "1992-11-11", end: nil, ended: nil)),
                      Place(type: "stadium", name: "Warszawa 4", address: "adres4", coordinates: Coordinates(latitude: "40", longitude: "40"), lifeSpan: nil),
                      Place(type: "stadium", name: "Warszawa 5", address: "adres5", coordinates: nil, lifeSpan: LifeSpan(begin: "1992-11-11", end: nil, ended: nil))]
        let placesResponse = PlaceResponse(count: 5, offset: 0, places: places)
        completion(placesResponse, nil)
    }
    
}

class MusicServiceWrongMock: MusicServiceProtocol {
    func loadData(for place: String, limit: Int, offset: Int, completion: @escaping (PlaceResponse?, Error?) -> ()) {
        let places = [Place(type: "stadium", name: "Warszawa 1", address: "adres1", coordinates: Coordinates(latitude: "10", longitude: "10"), lifeSpan: LifeSpan(begin: "1991", end: nil, ended: nil)),
                      Place(type: "stadium", name: "Warszawa 2", address: "adres2", coordinates: Coordinates(latitude: "20", longitude: "20"), lifeSpan: LifeSpan(begin: "1989", end: nil, ended: nil)),
                      Place(type: "stadium", name: "Warszawa 3", address: "adres3", coordinates: Coordinates(latitude: "30", longitude: "30"), lifeSpan: LifeSpan(begin: "1992-11-11", end: nil, ended: nil)),
                      Place(type: "stadium", name: "Warszawa 4", address: "adres4", coordinates: Coordinates(latitude: "40", longitude: "40"), lifeSpan: nil),
                      Place(type: "stadium", name: "Warszawa 5", address: "adres5", coordinates: nil, lifeSpan: LifeSpan(begin: "1992-11-11", end: nil, ended: nil))]
        let placesResponse = PlaceResponse(count: 5, offset: 0, places: places)
        completion(placesResponse, CustomError.someError)
    }
    
}
