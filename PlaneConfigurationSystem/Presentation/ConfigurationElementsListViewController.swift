//
//  ViewController.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import UIKit

class ConfigurationElementsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Private Properties
    private let loader = ConfigurationElementsLoader()
    
    private let mockData = [
        ConfigurationElementModel(
            pk: 1,
            name: "Обивка кресел",
            price: "3000.00",
            keyInfo: "Сделана из экокожи",
            category: "Салон",
            image: nil,
            detailText: "Обивка кресел выполнена из высококачественной экокожи с возможностью выбора цвета.",
            isDeleted: false
        ),
        ConfigurationElementModel(
            pk: 2,
            name: "Освещение салона",
            price: "2000.00",
            keyInfo: "RGB освещение",
            category: "Освещение",
            image: nil,
            detailText: "Многоцветное LED-освещение с динамическим переключением режимов для комфорта пассажиров.",
            isDeleted: false
        ),
        ConfigurationElementModel(
            pk: 3,
            name: "Багажные полки",
            price: "4000.00",
            keyInfo: "Вместимость 50 литров",
            category: "Салон",
            image: nil,
            detailText: "Удобные багажные полки с увеличенной вместимостью и легким доступом для пассажиров.",
            isDeleted: false
        )
    ]

    private var configurationElements: [ConfigurationElementModel] = []
    
    // UI
    private lazy var elementsTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConfigurationElementsTableViewCell.self, forCellReuseIdentifier: "ConfigurationElement")
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl() 
        loadData()
        setUpElementsTable()
        title = "Table of elements"
    }
    // MARK: - Public Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configurationElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationElement", for: indexPath) as? ConfigurationElementsTableViewCell else {
            return .init()
        }
        
        cell.cellConfigure(with: configurationElements[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        190
    }
    
    // MARK: - Private Methods

    private func setUpElementsTable() {
        view.addSubview(elementsTable)

        elementsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            elementsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            elementsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            elementsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            elementsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func loadData() {
        loader.loadConfigurationElements { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let elementsList):
                self.configurationElements = elementsList.configurationElements
                DispatchQueue.main.async {
                    self.elementsTable.reloadData()
                }
            case .failure(let error):
                print("Failed to load data: \(error.localizedDescription)")
                self.configurationElements = mockData
                DispatchQueue.main.async {
                    self.elementsTable.reloadData()
                }
            }
        }
    }
    
    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        elementsTable.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        loadData() // Загружаем данные

        // Завершаем анимацию обновления
        DispatchQueue.main.async {
            self.elementsTable.refreshControl?.endRefreshing()
        }
    }
}
