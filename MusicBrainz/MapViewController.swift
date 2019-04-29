//
//  ViewController.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    
    private let presenter = MapPresenter(service: MusicService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        textField.delegate = self
        presenter.attach(view: self)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let place = textField.text, !place.isEmpty,
            let formatedPlace = place.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return textField.endEditing(false) }
        presenter.loadData(for: formatedPlace)
        return textField.endEditing(false)
    }
    
}

extension MapViewController: MapView {
    func show(mark: PlaceMark) {
        mapView.addAnnotation(mark)
        mapView.setCenter(mark.coordinate, animated: true)
    }
    
}

