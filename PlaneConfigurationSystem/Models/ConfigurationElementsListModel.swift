//
//  ConfigurationElementsModel.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import Foundation

struct ConfigurationElementsListModel: Decodable {
    let draftID: Int?
    let draftCount: Int
    let configurationElements: [ConfigurationElementModel]
    
    enum CodingKeys: String, CodingKey {
        case draftID = "draft_configuration_id"
        case draftCount = "draft_elements_count"
        case configurationElements = "configuration_elements"
    }
}
