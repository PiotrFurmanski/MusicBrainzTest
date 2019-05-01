//
//  MapPresenter.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

protocol MapView: class {
    func show(mark: PlaceMark)
    func centerCamera(on mark: PlaceMark?)
}

class MapPresenter {
    private struct Constants {
        static let limit = 20
        static let year = 1990
    }
    
    var placeMarks = [PlaceMark]()
    var places = [Place]()
    
    private let musicService: MusicServiceProtocol
    private weak var mapView: MapView?
    
    
    init(service: MusicServiceProtocol) {
        musicService = service
    }
    
    func remove(mark: PlaceMark) {
        placeMarks = placeMarks.filter {
            return $0.coordinate.latitude != mark.coordinate.latitude ||
                $0.coordinate.longitude != mark.coordinate.longitude
        }
    }
    
    func loadData(for place: String, completion: (() -> ())? = nil) {
        places = [Place]()
        DispatchQueue.global(qos: .background).async { [weak self] in
            var offset = 0
            let downloadGroup = DispatchGroup()
            downloadGroup.enter()
            self?.musicService.loadData(for: place, limit: Constants.limit,
                                        offset: offset) { [weak self] (placeResponse, error) in
                guard let strongSelf = self, let placeResponse = placeResponse, error == nil else {
                    downloadGroup.leave()
                    return
                }
                                            
                strongSelf.places.append(contentsOf: placeResponse.places)
                
                while placeResponse.count > Constants.limit * (offset + 1) {
                    downloadGroup.enter()
                    offset += 1
                    strongSelf.musicService.loadData(for: place,
                                                     limit: Constants.limit,
                                                     offset: offset) { [weak self] (placeResponse, error) in
                                                        
                        guard let strongSelf = self, let placeResponse = placeResponse, error == nil else {
                            downloadGroup.leave()
                            return
                        }
                        
                        strongSelf.places.append(contentsOf: placeResponse.places)
                        downloadGroup.leave()
                    }
                }
                downloadGroup.leave()
            }
            downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
                self?.addFilteredMarks()
                completion?()
            }
        }
    }
    
    private func addFilteredMarks() {
        let filteredPlaces = places.filter {
            guard let begin = $0.lifeSpan?.begin, let beginInt = Int(String(begin.prefix(4))) else { return false }
            return beginInt >= Constants.year
        }
    
        let filteredPlaceMarks = filteredPlaces.compactMap({ PlaceMark(place: $0) })
        placeMarks.append(contentsOf: filteredPlaceMarks)
        
        for mark in filteredPlaceMarks {
            mapView?.show(mark: mark)
        }
        
        mapView?.centerCamera(on: placeMarks.last)
    }
    
    func attach(view: MapView) {
        mapView = view
    }
}
