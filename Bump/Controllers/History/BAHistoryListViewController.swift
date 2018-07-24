//
//  BAHistoryListViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class BAHistoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 75.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "History"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor    :    UIColor.Grayscale.dark,
            .font               :    UIFont.avenirBold(size: 30.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(20.0)
            make.leading.equalTo(self.view).offset(30.0)
            make.trailing.bottom.equalTo(self.view).offset(-20.0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 
    }
}
