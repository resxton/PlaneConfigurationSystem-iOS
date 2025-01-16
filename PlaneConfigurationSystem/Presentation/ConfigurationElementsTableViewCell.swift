//
//  ConfigurationElementsTableViewCell.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import UIKit

final class ConfigurationElementsTableViewCell: UITableViewCell {
    private let imageManager = ImageManager.shared
    private let elementImage: UIImageView = NetworkImageView()
    private let elementTitle: UILabel = UILabel()
    private let elementKeyInfo: UILabel = UILabel()
    private let elementCategory: UILabel = UILabel()
    private let elementPrice: UILabel = UILabel()
    private let gap: CGFloat = 10
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [elementImage, elementTitle, elementKeyInfo, elementCategory, elementPrice].forEach {
            addSubview($0)
        }
        
        setUpUIElements()
    }
    
    
    func setUpUIElements() {
        setUpImage()
        setUpTitle()
        setUpPrice()
        setUpCategory()
        setUpKeyInfo()
    }
    
    private func setUpImage() {
        elementImage.translatesAutoresizingMaskIntoConstraints = false
        elementImage.layer.cornerRadius = 10
        elementImage.clipsToBounds = true
        elementImage.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            elementImage.topAnchor.constraint(equalTo: topAnchor, constant: gap),
            elementImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -gap),
            elementImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gap),
            elementImage.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setUpTitle() {
        elementTitle.translatesAutoresizingMaskIntoConstraints = false
        elementTitle.font = .boldSystemFont(ofSize: 24)
        
        NSLayoutConstraint.activate([
            elementTitle.topAnchor.constraint(equalTo: topAnchor, constant: gap),
            elementTitle.leadingAnchor.constraint(equalTo: elementImage.trailingAnchor, constant: gap),
            elementTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gap),
            elementTitle.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setUpKeyInfo() {
        elementKeyInfo.translatesAutoresizingMaskIntoConstraints = false
        elementKeyInfo.font = .systemFont(ofSize: 16)
        elementKeyInfo.numberOfLines = 0
        elementKeyInfo.lineBreakMode = .byWordWrapping
//        elementKeyInfo.layer.borderWidth = 1
//        elementKeyInfo.layer.borderColor = UIColor.white.cgColor
        
        NSLayoutConstraint.activate([
            elementKeyInfo.topAnchor.constraint(equalTo: elementTitle.bottomAnchor, constant: gap),
            elementKeyInfo.leadingAnchor.constraint(equalTo: elementImage.trailingAnchor, constant: gap),
            elementKeyInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gap),
            elementKeyInfo.bottomAnchor.constraint(equalTo: elementCategory.topAnchor, constant: -gap)
        ])
    }
    
    private func setUpCategory() {
        elementCategory.translatesAutoresizingMaskIntoConstraints = false
        elementCategory.font = .italicSystemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
            elementCategory.bottomAnchor.constraint(equalTo: elementPrice.topAnchor, constant: -gap),
            elementCategory.leadingAnchor.constraint(equalTo: elementImage.trailingAnchor, constant: gap),
            elementCategory.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gap),
            elementCategory.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setUpPrice() {
        elementPrice.translatesAutoresizingMaskIntoConstraints = false
        elementPrice.font = .boldSystemFont(ofSize: 20)
        
        NSLayoutConstraint.activate([
            elementPrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -gap),
            elementPrice.leadingAnchor.constraint(equalTo: elementImage.trailingAnchor, constant: gap),
            elementPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gap),
            elementPrice.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func cellConfigure(with model: ConfigurationElementModel) {
        elementTitle.text = model.name
        elementKeyInfo.text = model.keyInfo
        elementCategory.text = "Категория: " + model.category
        elementPrice.text = "$ " + model.price
        
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
}
