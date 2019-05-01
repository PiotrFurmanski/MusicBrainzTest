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
}

class MapPresenter {
    private struct Constants {
        static let limit = 20
    }
    
    var placeMarks = [PlaceMark]()
    
    private let musicService: MusicServiceProtocol
    private weak var mapView: MapView?
    
    
    init(service: MusicServiceProtocol) {
        musicService = service
    }
    
    func loadData(for place: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            var offset = 0
            let downloadGroup = DispatchGroup()
            downloadGroup.enter()
            self?.musicService.loadData(for: place, limit: Constants.limit,
                                        offset: offset) { [weak self] (placeResponse, error) in
                guard let strongSelf = self, let placeResponse = placeResponse else {
                    downloadGroup.leave()
                    return
                }
                                            
                let placeMarks = placeResponse.places.compactMap({ PlaceMark(place: $0) })
                strongSelf.placeMarks.append(contentsOf: placeMarks)
                
                while placeResponse.count > Constants.limit * (offset + 1) {
                    downloadGroup.enter()
                    offset += 1
                    strongSelf.musicService.loadData(for: place,
                                                     limit: Constants.limit,
                                                     offset: offset) { [weak self] (placeResponse, error) in
                                                        
                        guard let strongSelf = self, let placeResponse = placeResponse else {
                            downloadGroup.leave()
                            return
                        }
                                                        
                        let placeMarks = placeResponse.places.compactMap({ PlaceMark(place: $0) })
                        strongSelf.placeMarks.append(contentsOf: placeMarks)
                        downloadGroup.leave()
                    }
                }
                downloadGroup.leave()
            }
            downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let strongSelf = self else { return }
                for mark in strongSelf.placeMarks {
                    strongSelf.mapView?.show(mark: mark)
                }
            }
        }
    }
    
    func attach(view: MapView) {
        mapView = view
    }
}
