//
//  PlaceResponse.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

struct PlaceResponse: Codable {
    var count: Int
    var offset: Int
    var places: [Place]
}
