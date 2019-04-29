//
//  MusicService.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

class MusicService {
    
    private struct Constant {
        static let accesKey = "a23267780d72bb4bf4da78d79eb3d80e"
    }
    
    func loadData(for place: String, completion: @escaping (_ placeResponse: PlaceResponse?, _ error: Error?) -> ()) {
        let apiUrlStr = "http://musicbrainz.org/ws/2/place/?query=\(place)&fmt=json"
        guard let url = URL(string: apiUrlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?,
                        completion: @escaping (_ placeResponse: PlaceResponse?, _ error: Error?) -> ()) {
        guard error == nil else {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let places = try decoder.decode(PlaceResponse.self, from: data)
            completion(places, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}
