//
//  MapViewMock.swift
//  MusicBrainzTests
//
//  Created by Piotr Furmanski on 01/05/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation
@testable import MusicBrainz

class MapViewMock: MapView {
    var numberOfMarks = 0
    var centerNumber = 0
    
    func show(mark: PlaceMark) {
        numberOfMarks += 1
    }
    
    func centerCamera(on mark: PlaceMark?) {
        centerNumber += 1
    }
}
