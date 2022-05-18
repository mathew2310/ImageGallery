//
//  MockNetworkManager .swift
//  ImageGalleryTests
//
//  Created by Mathew Ijidakinro on 16/05/2022.
//

import Foundation
@testable import ImageGallery
import Combine

class MockNetworkManager: Networking {
    func doApiCall(apiRequest: Requestable) -> Future<ImageGalleryResponce, NetworkError> {
    
        return Future { promise in
            
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:apiRequest.params["q"]!, withExtension:"json"),
                  let data = try? Data(contentsOf: url)

            else {
                promise(.failure(NetworkError.dataNotFound))
          
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(ImageGalleryResponce.self, from: data) else {
                return promise(.failure(NetworkError.parsingError))
            }
            
            return promise(.success(decodedResponse))
        }
    }
}
