//
//  ConfigurationElementViewController.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import UIKit

final class ConfigurationElementViewController: UIViewController {
    private let imageManager = ImageManager.shared

    private let elementTitle: UILabel = UILabel()
    private let elementImage: UIImageView = UIImageView()
    private let elementDetailInfo: UITextView = UITextView()
    private let elementPrice: UILabel = UILabel()
    private let gap: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUpUIElements()
        // Do any additional setup after loading the view.
    }
    
    func configure(with model: ConfigurationElementModel) {
        elementTitle.text = model.name
        elementDetailInfo.text = model.detailText
        elementPrice.text = "Стоимость: $" + model.price
        
        guard let imageURL = model.getFixedUrl() else {
            elementImage.image = UIImage(named: "MockImage")
            return
        }
        
        imageManager.loadImage(from: imageURL) { [weak self] result in
            switch result {
            case .success(let data):
                self?.elementImage.image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
                self?.elementImage.image = UIImage(named: "MockImage")
            }
        }
    }
    
    private func setUpUIElements() {
        setUpTitle()
        setUpImage()
        setUpPrice()
        setUpDetailInfo()
    }
    
    private func setUpTitle() {
        view.addSubview(elementTitle)
        elementTitle.font = .boldSystemFont(ofSize: 32)
        elementTitle.translatesAutoresizingMaskIntoConstraints = false
        elementTitle.textAlignment = .center
        
        NSLayoutConstraint.activate([
            elementTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: gap),
            elementTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gap),
            elementTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -gap),
            elementTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setUpImage() {
        view.addSubview(elementImage)
        elementImage.contentMode = .scaleAspectFit
        elementImage.translatesAutoresizingMaskIntoConstraints = false
        elementImage.layer.cornerRadius = 10
        elementImage.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            elementImage.topAnchor.constraint(equalTo: elementTitle.bottomAnchor, constant: gap),
            elementImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gap),
            elementImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -gap),
            elementImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setUpDetailInfo() {
        view.addSubview(elementDetailInfo)
        elementDetailInfo.translatesAutoresizingMaskIntoConstraints = false
        elementDetailInfo.font = .systemFont(ofSize: 20)
        elementDetailInfo.isEditable = false
        elementDetailInfo.isScrollEnabled = true
        elementDetailInfo.textAlignment = .left  // Устанавливаем выравнивание по левому краю
        
        NSLayoutConstraint.activate([
            elementDetailInfo.topAnchor.constraint(equalTo: elementImage.bottomAnchor, constant: gap),
            elementDetailInfo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gap),
            elementDetailInfo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -gap),
            elementDetailInfo.bottomAnchor.constraint(equalTo: elementPrice.topAnchor, constant: -gap)
        ])
        
        DispatchQueue.main.async {
            let range = NSRange(location: 0, length: 0)
            self.elementDetailInfo.scrollRangeToVisible(range)
        }
    }
    
    private func setUpPrice() {
        view.addSubview(elementPrice)
        elementPrice.font = .boldSystemFont(ofSize: 24)
        elementPrice.translatesAutoresizingMaskIntoConstraints = false
        elementPrice.textAlignment = .center
        
        NSLayoutConstraint.activate([
            elementPrice.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -gap),
            elementPrice.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gap),
            elementPrice.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -gap),
            elementPrice.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

}
