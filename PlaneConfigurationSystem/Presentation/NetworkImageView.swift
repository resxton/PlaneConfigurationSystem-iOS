//
//  NetworkImageView.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import UIKit

final class NetworkImageView: UIImageView {
    var currentUrl: URL?
    let shared = ImageManager.shared
    
    func loadImage(with url: URL) {
        currentUrl = url
        shared.loadImage(from: url) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                if self.currentUrl != url {
                    return
                }
                self.image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
}
