//
//  SyncUserAccountsView.swift
//  Bump
//
//  Created by Tim Wong on 7/9/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class SyncUserAccountsView: UIView, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let cellIdentifier = "SyncUserAccountsTableViewCellIdentifier"
    }
    
    let user: User
    var accounts: [(AccountContact, String, Bool)]
    
    var headerLabel: String?
    
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
        self.accounts = user.allAccounts.map { ($0.0, $0.1, true) }
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().offset(-32.0)
        }
        
        super.updateConstraints()
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
            view.detailLabel.text = headerLabel ?? "PICK WHAT TO SHARE"
            view.button.isHidden = false
            
            return view
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? TableViewCell ?? TableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let account = accounts[indexPath.section]
        
        cell.iconLabel.text = account.0.icon
        cell.valueLabel.text = account.1
        
        if account.2 {
            cell.accessoryType = .checkmark
            cell.backgroundColor = .white
            cell.iconLabel.textColor = UIColor.Matcha.dusk
            cell.valueLabel.textColor = UIColor.Matcha.dusk
            cell.layer.borderColor = UIColor.Matcha.dusk.cgColor
            cell.layer.borderWidth = 2.0
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.Grayscale.background
            cell.iconLabel.textColor = UIColor.Grayscale.light
            cell.valueLabel.textColor = UIColor.Grayscale.light
            cell.layer.borderWidth = 0.0
        }
        
        cell.layer.cornerRadius = 20.0
        
        cell.tintColor = UIColor.Matcha.dusk
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accounts[indexPath.section].2 = !accounts[indexPath.section].2
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
