//
//  Place.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

struct Coordinates: Codable {
    var latitude: String
    var longitude: String
}

struct LifeSpan: Codable {
    var begin: String?
    var end: String?
    var ended: Bool?
}

struct Place: Codable {
    var type: String?
    var name: String?
    var address: String?
    var coordinates: Coordinates?
    var lifeSpan: LifeSpan?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case address
        case coordinates
        case lifeSpan = "life-span"
    }
}
