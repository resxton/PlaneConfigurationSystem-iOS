//
//  ImageManager.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import Foundation

enum ImageManagerErrors: Error {
    case unexpectedError
}

protocol ImageManagerDescription {
    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImageManager: ImageManagerDescription {

    static let shared = ImageManager()
    private init() {}

    private let networkImageQueue = DispatchQueue(label: "networkImageQueue", attributes: .concurrent) // новый поток (конкуретный)
    
    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let mainTreadCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async { // асинхронно выполняем на главном потоке (последовательный), отвечает за UI
                completion(result)
            }
        }

        networkImageQueue.async { // асинхронно выполняем на созданном потоке, чтобы не тормозить ui
            guard let imageData = try? Data(contentsOf: url) else {
                mainTreadCompletion(.failure(ImageManagerErrors.unexpectedError))
                return
            }
            mainTreadCompletion(.success(imageData))
        }
    }
}
