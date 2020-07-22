
import Foundation

// https://www.yelp.com/developers/documentation/v3/business_search

struct Place: Codable {
  var id: String
  var name: String
  var image_url: String
  var rating: Double
  var review_count: Int
  var price: String?
  var is_closed: Bool
  var url: String
  var transactions: [String]
  
  var imageData: Data?
  var photos: [String]?
  var photoData: [Data]?
}

import UIKit

extension Place {
  var mainImage: UIImage? {
    guard let imageData = imageData else {
      return nil
    }
    return UIImage(data: imageData)
  }
  
  var images: [UIImage]? {
    guard let photoData = photoData else {
      return nil
    }
    
    return photoData.compactMap { UIImage(data: $0) }
  }
}
