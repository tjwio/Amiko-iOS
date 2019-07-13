//
//  ShipListViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/11/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

class ShipListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let cellIdentifier = "ShipListTableViewCellIdentifier"
    }
    
    let user: User
    
    let connectedShips: [Ship]
    let pendingShips: [Ship]
    
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
        self.connectedShips = ships.filter { !$0.pending }
        self.pendingShips = ships.filter { $0.pending }
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
        return connectedShips.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 52.0 : 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = DetailButtonHeaderView()
            view.detailLabel.font = .avenirDemi(size: 14.0)
            view.detailLabel.text = "CONNECTED"
            view.detailLabel.textColor = UIColor.Grayscale.dark
            view.button.isHidden = false
            
            return view
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? ShipTableViewCell ?? ShipTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let ship = connectedShips[indexPath.section]
        if let imageUrl = ship.user.imageUrl {
            cell.avatarImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: .blankAvatar)
        }
        
        cell.nameLabel.text = ship.user.fullName
        cell.bioLabel.text = ship.user.publicBio
        cell.accounts = ship.user.allAccounts
        
        return cell
    }
}
