//
//  MusicBrainzTests.swift
//  MusicBrainzTests
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import XCTest
@testable import MusicBrainz

class MapPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldSetTwoMarks() {
        
        let expect = expectation(description: "Waiting response")
        let mapView = MapViewMock()
        let mapPresenterUnderTest = MapPresenter(service: MusicServiceMock())
        mapPresenterUnderTest.attach(view: mapView)
        
        mapPresenterUnderTest.loadData(for: "warszawa") {
            expect.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(mapView.numberOfMarks, 2)
        XCTAssertEqual(mapView.centerNumber, 1)
    }
    
    func testShouldProperlyRemoveMark() {
        
        let expect = expectation(description: "Waiting response")
        let mapView = MapViewMock()
        let mapPresenterUnderTest = MapPresenter(service: MusicServiceMock())
        mapPresenterUnderTest.attach(view: mapView)
        
        mapPresenterUnderTest.loadData(for: "warszawa") {
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(mapPresenterUnderTest.placeMarks.count, 2)
        
        let place = Place(type: "stadium", name: "Warszawa 1", address: "adres1",
                              coordinates: Coordinates(latitude: "10", longitude: "10"),
                              lifeSpan: LifeSpan(begin: "1991", end: nil, ended: nil))
        if let placeMark = PlaceMark(place: place) {
            mapPresenterUnderTest.remove(mark: placeMark)
        }
        XCTAssertEqual(mapPresenterUnderTest.placeMarks.count, 1)
    }
    
}
