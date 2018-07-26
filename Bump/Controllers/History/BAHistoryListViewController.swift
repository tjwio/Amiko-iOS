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
    
    private struct Constants {
        static let cellIdentifier = "BAHistoryCardTableViewCellIdentifier"
    }
    
    let user: BAUser
    
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
    
    init(user: BAUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "History"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor    :    UIColor.Grayscale.dark,
            .font               :    UIFont.avenirBold(size: 18.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor    :    UIColor.Grayscale.dark,
            .font               :    UIFont.avenirBold(size: 30.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        
        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.dismissViewController(_:)))
        closeBarButtonItem.tintColor = UIColor.Grayscale.dark
        closeBarButtonItem.setAllTitleTextAttributes([.font : UIFont.avenirRegular(size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)])
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
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
    
    @objc private func dismissViewController(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return user.history.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? BAUserCardTableViewCell ?? BAUserCardTableViewCell(style: .default, reuseIdentifier: Constants.cellIdentifier)
        
        let history = user.history[indexPath.section]
        
        cell.dateLabel.text = "Connected on \(history.date.string(formatter: .monthDayYear))"
        cell.jobLabel.text = "iOS Engineer"
        cell.locationLabel.text = "at San Francisco Convention Center"
        cell.nameLabel.text = history.addedUser.fullName
        cell.phoneLabel.text = history.addedUser.phone
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
