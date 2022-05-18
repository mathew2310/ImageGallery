//
//  ImageGalleryRecord.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 12/05/2022.
//

import Foundation
import UIKit

enum ImageRecordState {
  case new, downloaded, failed
}

class ImageRecord {
  let name: String
  let url: String
  var state = ImageRecordState.new
  var image = UIImage(named: "Placeholder")
  
    init(name:String, url:String) {
    self.name = name
    self.url = url
  }
}
