//
//  ImageDownloadOperation.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 10/05/2022.
//

import Foundation
import UIKit

protocol ImageOperations {
    
}
class ImageDownloader: Operation, ImageOperations {
    let imageRecord: ImageRecord
    
    init(_ imageRecord: ImageRecord) {
      self.imageRecord = imageRecord
    }
    
    override func main() {
      if isCancelled {
        return
      }
        
    guard let url = URL(string: imageRecord.url) else {return}
        
      guard let imageData = try? Data(contentsOf:url) else { return }
      
      if isCancelled {
        return
      }
      
      if !imageData.isEmpty {
        imageRecord.image = UIImage(data:imageData)
        imageRecord.state = .downloaded
      } else {
        imageRecord.state = .failed
        imageRecord.image = UIImage(named: "Failed")
      }
    }
  }


class PendingOperations {
    
  lazy var downloadsInProgress: [IndexPath: ImageOperations] = [:]
    
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 10
    return queue
  }()
}


