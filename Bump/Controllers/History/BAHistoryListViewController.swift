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
        static let firstHitPoint = CGRect(x: 100.0, y: 100.0, width: 1.0, height: 1.0)
    }
    
    let user: BAUser
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private var mainSection = 0
    
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
        navigationController?.navigationBar.isTranslucent = false
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
        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, view.bounds.size.height-200.0, 0.0)
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view).offset(20.0)
            make.trailing.bottom.equalTo(self.view).offset(-20.0)
        }
    }
    
    @objc private func dismissViewController(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: table view
    
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
        
        if let imageUrl = history.addedUser.imageUrl, let url = URL(string: imageUrl) {
            cell.avatarView.imageView.sd_setIndicatorStyle(.gray)
            cell.avatarView.imageView.sd_showActivityIndicatorView()
            cell.avatarView.imageView.sd_setImage(with: url, placeholderImage: .blankAvatar, options: .retryFailed) { (image, _, _, _) in
                history.addedUser.image.value = image
            }
        }
        else {
            cell.avatarView.imageView.image = .exampleAvatar
        }
        
        if indexPath.section == mainSection && !cell.isMain {
            cell.setIsMain(true, animted: false)
        }
        else if indexPath.section != mainSection && cell.isMain {
            cell.setIsMain(false, animted: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: scroll view
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = view.convert(Constants.firstHitPoint, to: tableView)
        if let curr = tableView.indexPathsForRows(in: point)?.first {
            
            if let cell = tableView.cellForRow(at: curr) as? BAUserCardTableViewCell, !cell.isMain {
                hapticGenerator.impactOccurred()
                mainSection = curr.section
                cell.setIsMain(true, animted: true)
                
                if curr.section > 0 {
                    let top = IndexPath(row: 0, section: curr.section-1)
                    
                    if let cell = tableView.cellForRow(at: top) as? BAUserCardTableViewCell, cell.isMain {
                        cell.setIsMain(false, animted: true)
                    }
                }
                
                if curr.section < user.history.count - 1 {
                    let bottom = IndexPath(row: 0, section: curr.section+1)
                    
                    if let cell = tableView.cellForRow(at: bottom) as? BAUserCardTableViewCell, cell.isMain {
                        cell.setIsMain(false, animted: true)
                    }
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
//            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
}
