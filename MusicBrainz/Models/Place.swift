//
//  Place.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

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
