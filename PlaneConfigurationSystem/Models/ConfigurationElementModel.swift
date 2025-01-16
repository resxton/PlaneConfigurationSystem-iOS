//
//  ConfigurationElementModel.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import Foundation


struct ConfigurationElementModel: Decodable {
    let pk: Int
    let name: String
    let price: String
    let keyInfo: String
    let category: String
    let image: URL?
    let detailText: String
    let isDeleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case pk
        case name
        case price
        case keyInfo = "key_info"
        case category
        case image
        case detailText = "detail_text"
        case isDeleted = "is_deleted"
    }
    
    func getFixedUrl() -> URL? {
        guard let imageURL = image else {
            print("Error: Image URL is nil.")
            return nil
        }
        
        let fixedURLString = imageURL.absoluteString.replacingOccurrences(of: "127.0.0.1", with: "172.20.10.2")
        
        guard let fixedURL = URL(string: fixedURLString) else {
            print("Error: Invalid fixed URL.")
            return nil
        }
        
        return fixedURL
    }
}
