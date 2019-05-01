//
//  MusicService.swift
//  MusicBrainz
//
//  Created by Piotr Furmanski on 29/04/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

protocol MusicServiceProtocol: class {
    func loadData(for place: String, limit: Int, offset: Int,
                  completion: @escaping (_ placeResponse: PlaceResponse?, _ error: Error?) -> ())
}

class MusicService: MusicServiceProtocol {
    
    private struct Constants {
        static let limit = "limit"
        static let offset = "offset"
    }
    
    func loadData(for place: String, limit: Int, offset: Int,
                  completion: @escaping (_ placeResponse: PlaceResponse?, _ error: Error?) -> ()) {
        let apiUrlStr = "http://musicbrainz.org/ws/2/place/?query=\(place)&\(Constants.limit)=\(limit)&\(Constants.offset)=\(offset)&fmt=json"
        guard let url = URL(string: apiUrlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?,
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
