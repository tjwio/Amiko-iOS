//
//  SyncUserViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/8/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import SnapKit

class SyncUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let user: User
    let accounts: [(AccountContact, String)]
    
    let headerView: SyncUserHeaderView = {
        let view = SyncUserHeaderView()
        view.backgroundColor = UIColor.Grayscale.background
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    init(user: User) {
        self.user = user
        self.accounts = user.allAccounts
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 64.0 : 12.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = DetailButtonHeaderView()
            view.detailLabel.text = "PICK WHAT TO SHARE"
            view.button.isHidden = false
            
            return view
        } else {
            return UIView()
        }
    }
}
