//
//  ViewController.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var navigationBar: CustomNavigationBar = {
        return CustomNavigationBar()
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var margins: UILayoutGuide { return view.layoutMarginsGuide }
    
    var models = [BLEManagerDeviceModel]()
    var displayModels : [BLEManagerDeviceModel] {
        return models.reversed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        initData()
    }
    
    func setNavigationBar() {
        view.addSubview(navigationBar)

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            navigationBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        navigationBar.settingNavigationBar(title: "TymphanyTest", titleAlignment: .center, rightTitle: "Stop") { [weak self] buttonClicked in
            switch buttonClicked {
            case.left:
                break
            case .right:
                BLEManager.shared.isScanning ? BLEManager.shared.stopScan() : BLEManager.shared.scan()
                self?.navigationBar.rightTitle = BLEManager.shared.isScanning ? "Stop" : "Scan"
            }
        }
    }
    
    func setUI() {
        view.backgroundColor = .white
        setNavigationBar()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.backgroundColor = .clear
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
              
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    func initData() {
        BLEManager.shared.scan()
        BLEManager.shared.delegate = self
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        cell.configure(displayModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEManager.shared.connectTo(model: displayModels[indexPath.row])
    }
}

extension ViewController: BLEManagerDelegate {
    func didDiscover(model: BLEManagerDeviceModel) {
        if let index = models.firstIndex(where: { $0.identifier == model.identifier }) {
            models.remove(at: index)
        }
        models.append(model)
        tableView.reloadData()
    }
}
