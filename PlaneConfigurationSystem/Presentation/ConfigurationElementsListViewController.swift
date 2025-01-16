//
//  ViewController.swift
//  PlaneConfigurationSystem
//
//  Created by Сомов Кирилл on 16.01.2025.
//

import UIKit

final class ConfigurationElementsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Private Properties
    private let loader = ConfigurationElementsLoader()
    private let categories = ["Все категории", "Дизайн салона", "Компоновка салона", "Авионика", "Двигатель", "Кресло"]
    private var selectedCategory: String = "Все категории" {
        didSet {
            filterElementsByCategory()
        }
    }
    
    private var mockFlag = false
    
    private let mockData = [
        ConfigurationElementModel(
            pk: 1,
            name: "Обивка кресел",
            price: "3000.00",
            keyInfo: "Сделана из экокожи",
            category: "Кресло",
            image: nil,
            detailText: "Обивка кресел выполнена из высококачественной экокожи с возможностью выбора цвета.",
            isDeleted: false
        ),
        ConfigurationElementModel(
            pk: 2,
            name: "Освещение салона",
            price: "2000.00",
            keyInfo: "RGB освещение",
            category: "Дизайн салона",
            image: nil,
            detailText: "Многоцветное LED-освещение с динамическим переключением режимов для комфорта пассажиров.",
            isDeleted: false
        ),
        ConfigurationElementModel(
            pk: 3,
            name: "Багажные полки",
            price: "4000.00",
            keyInfo: "Вместимость 50 литров",
            category: "Компоновка салона",
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
    
    private lazy var categoryPicker: UIPickerView = {
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            return picker
        }()
        
        private lazy var categoryToolbar: UIToolbar = {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didSelectCategory))
            toolbar.setItems([doneButton], animated: true)
            return toolbar
        }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRefreshControl() 
        loadData()
        setUpElementsTable()
        view.backgroundColor = .systemBackground
        title = "Элементы конфигурации"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(rightButtonTapped))
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let elementVC = ConfigurationElementViewController()
        elementVC.configure(with: self.configurationElements[indexPath.row])
        self.navigationController?.pushViewController(elementVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    private func loadData(with category: String) {
        loader.loadConfigurationElements(with: selectedCategory) { [weak self] result in
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
                mockFlag = true
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
        selectedCategory = "Все категории"
        categoryPicker.selectRow(0, inComponent: 0, animated: true)  // Сбросить выбор в пикере на первую категорию ("Все категории")

        // Завершаем анимацию обновления
        DispatchQueue.main.async {
            self.elementsTable.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func rightButtonTapped() {
        // Показать пикер с категориями
        let pickerViewController = UIViewController()
        
        // Добавляем пикер и тулбар
        pickerViewController.view.addSubview(categoryPicker)
        pickerViewController.view.addSubview(categoryToolbar)
        
        categoryPicker.backgroundColor = .systemBackground
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: pickerViewController.view.topAnchor),
            categoryPicker.leadingAnchor.constraint(equalTo: pickerViewController.view.leadingAnchor),
            categoryPicker.trailingAnchor.constraint(equalTo: pickerViewController.view.trailingAnchor),
            categoryPicker.bottomAnchor.constraint(equalTo: pickerViewController.view.bottomAnchor, constant: -44), // для тулбара
            categoryToolbar.leadingAnchor.constraint(equalTo: pickerViewController.view.leadingAnchor),
            categoryToolbar.trailingAnchor.constraint(equalTo: pickerViewController.view.trailingAnchor),
            categoryToolbar.topAnchor.constraint(equalTo: pickerViewController.view.topAnchor)
        ])
        
        present(pickerViewController, animated: true, completion: nil)
    }

    @objc private func didSelectCategory() {
        dismiss(animated: true) {
            // Обновляем выбранную категорию
            self.filterElementsByCategory()
        }
    }
    
    private func filterElementsByCategory() {
        if !mockFlag {
            if selectedCategory == "Все категории" {
                loadData()
            } else {
                loadData(with: selectedCategory)
            }
        } else {
            let filteredElements = configurationElements.filter { $0.category == selectedCategory }
            configurationElements = filteredElements
        }
        
        elementsTable.reloadData()
    }
}

extension ConfigurationElementsListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
}
