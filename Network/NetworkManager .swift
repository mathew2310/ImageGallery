//
//  NetworkManager .swift
//  ImageGallery
//
//  Created by Mathew Ijidakinro on 05/05/2022.
//

import Foundation
import Combine

protocol Networking {
    func doApiCall(apiRequest:Requestable)-> Future<ImageGalleryResponce, NetworkError>
}

class NetworkManager: Networking {
    let session:URLSession
    init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    func doApiCall(apiRequest: Requestable) -> Future<ImageGalleryResponce, NetworkError> {
        return Future { [weak self] promise in
            guard let request = URLRequest.getURLRequest(for: apiRequest) else {
                promise(.failure(NetworkError.failedToCreateRequest))
                return
            }
            self?.session.dataTask(with: request, completionHandler: { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    return promise(.failure(NetworkError.dataNotFound))
                }
                guard let _data = data, error == nil else {
                    return promise(.failure(NetworkError.dataNotFound))
                }
             
                guard let decodedResponse = try? JSONDecoder().decode(ImageGalleryResponce.self, from: _data) else {
                    return promise(.failure(NetworkError.parsingError))
                }
            
                return promise(.success(decodedResponse))
            }).resume()
        }
    }
}

extension URLRequest {
    static func getURLRequest(for apiRequest:Requestable)-> URLRequest? {
        if let url = URL(string:apiRequest.baseUrl.appending(apiRequest.path)),
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
            let queryItems = apiRequest.params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            urlComponents.queryItems = queryItems
            let urlRequest = URLRequest(url: urlComponents.url!)
            return urlRequest
        } else {
            return nil
        }
    }
}
