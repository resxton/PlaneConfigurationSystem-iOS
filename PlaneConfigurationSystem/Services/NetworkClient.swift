//
//  NetworkClient.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import Foundation

protocol NetworkClientProtocol {
    static func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    
    private enum NetworkError: Error {
        case responseError
        case noInternetConnection
    }
    
    static func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                // Проверяем на отсутствие соединения
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    handler(.failure(NetworkError.noInternetConnection))
                } else {
                    handler(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.responseError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
