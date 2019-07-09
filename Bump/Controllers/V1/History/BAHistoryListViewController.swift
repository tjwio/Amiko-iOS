//
//  BAHistoryListViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/22/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class BAHistoryListViewController: UIViewController, BAHistoryViewController, UITableViewDataSource, UITableViewDelegate {
    
    private struct Constants {
        static let cellIdentifier = "BAHistoryCardTableViewCellIdentifier"
        static let firstHitPoint = CGRect(x: 100.0, y: 154.0, width: 1.0, height: 1.0) //+54.0 for uinavigationbar
    }
    
    weak var delegate: BAHistoryChangeDelegate?
    
    let user: User
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var isListVisible = true
    
    private var isScrollingFromMap = false
    private var currentIndexPath: IndexPath?
    
    init(user: User, delegate: BAHistoryChangeDelegate? = nil) {
        self.user = user
        self.delegate = delegate
        if !user.history.isEmpty {
            currentIndexPath = IndexPath(row: 0, section: 0)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "History"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor    :    UIColor.Grayscale.dark,
            .font               :    UIFont.avenirBold(size: 18.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor    :    UIColor.Grayscale.dark,
            .font               :    UIFont.avenirBold(size: 30.0) ?? UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        
        (navigationController?.navigationBar as? BANavigationBar)?.addExtraPadding = true
        navigationController?.view.layer.cornerRadius = 8.0
        navigationController?.view.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets.top = 10.0
        }
        
//        let closeBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.dismissViewController(_:)))
//        closeBarButtonItem.tintColor = UIColor.Grayscale.dark
//        closeBarButtonItem.setAllTitleTextAttributes([.font : UIFont.avenirRegular(size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)])
//        navigationItem.leftBarButtonItem = closeBarButtonItem
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets.init(top: 20.0, left: 0.0, bottom: view.bounds.size.height-200.0, right: 0.0)
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
    
    ///MARK: history change delegate
    
    func showEntry(_ entry: BAHistory) {
        if let index = user.history.firstIndex(of: entry) {
            isScrollingFromMap = true
            let indexPath = IndexPath(row: 0, section: index)
            
            if let curr = currentIndexPath, let cell = tableView.cellForRow(at: curr) as? BAUserCardTableViewCell {
                cell.setIsMain(false, animted: false)
            }
            if let cell = tableView.cellForRow(at: indexPath) as? BAUserCardTableViewCell {
                cell.setIsMain(true, animted: false)
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            currentIndexPath = indexPath
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.isScrollingFromMap = false
            }
        }
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
        cell.locationLabel.text = "at San Francisco Convention Center"
        cell.nameLabel.text = history.addedUser.fullName
        cell.phoneLabel.text = history.addedUser.phone
        cell.socialDrawer.items = history.addedUser.socialAccounts
        cell.socialDrawer.selectCallback = AppConstants.defaultSocialCallback
        
        if let fullJobCompany = history.addedUser.fullJobCompany {
            cell.jobLabel.isHidden = false
            cell.jobLabel.text = fullJobCompany
        }
        else {
            cell.jobLabel.isHidden = true
        }
        
        if history.addedUser.imageUrl != nil {
            cell.avatarView.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.avatarView.imageView.sd_imageIndicator?.startAnimatingIndicator()
            
            history.addedUser.loadImage(success: { (image, colors) in
                cell.avatarView.imageView.image = image
                cell.avatarView.imageView.sd_imageIndicator?.stopAnimatingIndicator()
                cell.headerView.backgroundColor = colors.background
            }) { _ in
                cell.avatarView.imageView.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
        else {
            cell.avatarView.imageView.image = .blankAvatar
            cell.avatarView.sd_imageIndicator = nil
        }
        
        if indexPath.section == currentIndexPath?.section && !cell.isMain {
            cell.setIsMain(true, animted: false)
        }
        else if indexPath.section != currentIndexPath?.section && cell.isMain {
            cell.setIsMain(false, animted: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? BAUserCardTableViewCell else { return }
        guard cell.isMain else { setMainCell(cell, indexPath: indexPath, currMain: currentIndexPath); return }
        
        let viewController = BADeleteUserViewController(user: user, history: user.history[indexPath.section])
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.successCallback = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        self.parent?.parent?.present(viewController, animated: true, completion: nil)
    }
    
    //MARK: scroll view
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScrollingFromMap else { return }
        
        let point = view.convert(Constants.firstHitPoint, to: tableView)
        if let curr = tableView.indexPathsForRows(in: point)?.first {
            
            if let cell = tableView.cellForRow(at: curr) as? BAUserCardTableViewCell, !cell.isMain {
                setMainCell(cell, indexPath: curr)
            }
        }
    }
    
    private func setMainCell(_ cell: BAUserCardTableViewCell, indexPath: IndexPath, currMain: IndexPath? = nil) {
        hapticGenerator.impactOccurred()
        currentIndexPath = indexPath
        cell.setIsMain(true, animted: true)
        delegate?.historyController(self, didSelect: user.history[indexPath.section])
        
        if let currMain = currMain, let cell = tableView.cellForRow(at: currMain) as? BAUserCardTableViewCell, cell.isMain {
            cell.setIsMain(false, animted: true)
        }
        else {
            if indexPath.section > 0 {
                let top = IndexPath(row: 0, section: indexPath.section-1)
                
                if let cell = tableView.cellForRow(at: top) as? BAUserCardTableViewCell, cell.isMain {
                    cell.setIsMain(false, animted: true)
                }
            }
            
            if indexPath.section < user.history.count - 1 {
                let bottom = IndexPath(row: 0, section: indexPath.section+1)
                
                if let cell = tableView.cellForRow(at: bottom) as? BAUserCardTableViewCell, cell.isMain {
                    cell.setIsMain(false, animted: true)
                }
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}