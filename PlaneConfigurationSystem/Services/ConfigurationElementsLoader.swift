//
//  ConfigurationElementsLoader.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import Foundation

class ConfigurationElementsLoader {
    private var configurationElementsURL: URL {
        guard let url = URL(string: "http://172.20.10.2:8000/plane_configuration_elements/") else {
            preconditionFailure("Wrong url")
        }
        return url
    }
    
    func loadConfigurationElements(handler: @escaping (Result<ConfigurationElementsListModel, Error>) -> Void) {
        NetworkClient.fetch(url: configurationElementsURL) { result in
            switch result {
            case .success(let data):
                do {
                    let configurationElementsList = try JSONDecoder().decode(ConfigurationElementsListModel.self, from: data)
                    handler(.success(configurationElementsList))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func loadConfigurationElements(with category: String, handler: @escaping (Result<ConfigurationElementsListModel, Error>) -> Void) {
        NetworkClient.fetch(url: configurationElementsURL, category: category) { result in
            switch result {
            case .success(let data):
                do {
                    let configurationElementsList = try JSONDecoder().decode(ConfigurationElementsListModel.self, from: data)
                    handler(.success(configurationElementsList))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
