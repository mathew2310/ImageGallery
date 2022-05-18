//
//  GalleryViewModel.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 16/05/22.
//

import Foundation


enum ImageState {
    case startDownLoad(IndexPath)
    case downLoadCompleted(IndexPath)
    case none
}

class GalleryViewModel {
    
    let imageRecords: [ImageRecord]
    let pendingOperations = PendingOperations()
    
    @Published var imageState:ImageState = ImageState.none

    init(imageRecords: [ImageRecord]) {
        self.imageRecords = imageRecords
    }
    
    func startDownload(imageDownloader:ImageOperations, at indexPath: IndexPath) {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        if let downloader = imageDownloader as? Operation {
            downloader.completionBlock = {
                if downloader.isCancelled {
                    return
                }
                
                DispatchQueue.main.async {
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                    
                    self.imageState = .downLoadCompleted(indexPath)
                }
            }
            pendingOperations.downloadQueue.addOperation(downloader)
        }
        pendingOperations.downloadsInProgress[indexPath] = imageDownloader
    }
}
