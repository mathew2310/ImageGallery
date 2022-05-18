//
//  ViewModel.swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 05/05/2022.
//

import Foundation
import Combine


protocol ImageSearchGalleryViewModelType {
    var stateBinding: Published<ViewState>.Publisher { get }
    var imageRecords:[ImageRecord] { get }
    func search(keyword: String)
    func clearChachedData()
}

final class ImageSearchGalleryViewModel: ImageSearchGalleryViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    
    private let networkManager:Networking
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var imageRecords: [ImageRecord] = []
    
    var cachedRecords:[String: [ImageRecord]] = [:]
    
    
    init(networkManager:Networking) {
        self.networkManager = networkManager
    }
    
    func search(keyword: String) {
        
       let trimedKeyWord =  keyword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let imageRecords = cachedRecords[trimedKeyWord] {
            self.imageRecords = imageRecords
            self.state = ViewState.finishedLoading
        } else {
            searchImages(keyword: trimedKeyWord)
        }
    }
    
    func clearChachedData() {
        self.cachedRecords = [:]
    }
    
    private func searchImages(keyword: String) {
        let request = Request(baseUrl: APIEndPoints.baseURL, path: "", params: ["q":"\(keyword)", "key":APIEndPoints.apiKey,  "image_type" : "photo"])
        
        state = ViewState.loading
        let publisher = networkManager.doApiCall(apiRequest: request)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.imageRecords = []
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] imageGalleryResponce in
            
            let imageRecords = imageGalleryResponce.hits.map {
                ImageRecord(name: $0.user, url: $0.largeImageURL)
            }
            if imageRecords.count > 0 {
                self?.imageRecords = imageRecords
                self?.cachedRecords[keyword] = self?.imageRecords
                self?.state = ViewState.finishedLoading

            }else {
                self?.state = ViewState.error("Data not found, pls try for different keyword")
            }
        }
        self.cancellables.insert(cancalable)
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
