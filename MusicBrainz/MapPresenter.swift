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
    private let musicService: MusicService
    private weak var mapView: MapView?
    
    init(service: MusicService) {
        musicService = service
    }
    
    func loadData(for place: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.musicService.loadData(for: place) { (placeResponse, error) in
                DispatchQueue.main.async {
                    guard let places = placeResponse?.places else { return }
                    for place in places {
                        if let mark = PlaceMark(place: place) {
                            self?.mapView?.show(mark: mark)
                        }
                    }
                }
            }
        }
    }
    
    func attach(view: MapView) {
        mapView = view
    }
}
