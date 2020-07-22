//
//  NetworkManager.swift
//   
//
//  Created by Sam Meech-Ward on 2020-05-15.
//  Copyright © 2020 Sam Meech-Ward. All rights reserved.
//

import Foundation
import UIKit

struct ApiResult: Codable {
  var total: Int
  var businesses: [Place]
}

class NetworkManager {
  
  let network = Network()

  
  private func downloadImage(_ urlString: String, completion: @escaping (Data?) -> ()) {
    let url = URL(string: urlString)!

    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
      guard let localURL = localURL else {
        print("no local url")
        return
      }
      
      let data = try? Data(contentsOf: localURL)
      
      completion(data)
    }

    task.resume()
  }
  
  func getPlace(id: String, completion: @escaping (Place?, Error?) -> Void) {
    network.getPlaceWithId(id) { data, response, error in
      if let error = error {
        print("error \(error)")
        return
      }
      
      guard let data = data else {
        print("error")
        return
      }
      
      var result: Place? = nil
      
      do {
        result = try JSONDecoder().decode(Place.self, from: data)
      }
      catch let e {
        print("getPlace error with api results \(e)")
        return
      }
      
      let dispatchGroup = DispatchGroup()
      
      result?.photoData = []
      
      dispatchGroup.enter()
      self.downloadImage(result!.image_url) { data in
        result?.imageData = data!
        dispatchGroup.leave()
      }
      
      result?.photos?.forEach({ photo in
        dispatchGroup.enter()
        self.downloadImage(photo) { data in
          result?.photoData?.append(data!)
          dispatchGroup.leave()
        }
      })
      
      let queue = DispatchQueue.main
      
      dispatchGroup.notify(queue: queue) {
        completion(result, nil)
      }
      
//      OperationQueue.main.addOperation {
//        completion(result, nil)
//      }
      
    }
  }
  
  func getPlaces(term: String, completion: @escaping ([Place]?, Error?) -> Void) {
    network.getPlaces(term) { data, response, error in
      if let error = error {
        print("error \(error)")
        return
      }
      
      guard let data = data else {
        print("error")
        return
      }
      
      var results: ApiResult? = nil
      
      do {
        results = try JSONDecoder().decode(ApiResult.self, from: data)
      }
      catch let e {
        print("getPlaces error with api results \(e)")
        return
      }

      let dispatchGroup = DispatchGroup()
      
      var allPlaces: [Place] = []
      results!.businesses.forEach { place in
        dispatchGroup.enter()
        self.getPlace(id: place.id) { place2, err in
          allPlaces.append(place2!)
          dispatchGroup.leave()
        }
      }
      
      let queue = DispatchQueue.main
      dispatchGroup.notify(queue: queue) {
        completion(allPlaces, nil)
      }
      
      
      
//      OperationQueue.main.addOperation {
//        completion(results?.businesses, nil)
//      }
      
    }
    
  }
  
  
}
