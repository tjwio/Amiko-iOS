//
//  ShipListViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/11/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class ShipListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let user: User
    let ships: [Ship]
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 64.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(user: User, ships: [Ship]) {
        self.user = user
        self.ships = ships
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Amikoships"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Grayscale.dark,
            .font: UIFont.avenirDemi(size: 16.0)!
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ships.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
