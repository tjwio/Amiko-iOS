//
//  ShipListViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/11/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

protocol ShipController: UIViewController {
    var ships: [Ship] { get }
}

class ShipListViewController: UIViewController, ShipController, ShipTableViewCellDelegate, PendingShipHeaderViewDelegate, SyncUserPendingViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    private struct Constants {
        static let cellIdentifier = "ShipListTableViewCellIdentifier"
    }
    
    let user: User
    
    var connectedShips: [Ship]
    var pendingShips: [Ship]
    
    var ships: [Ship] { return connectedShips }
    
    weak var delegate: ShipViewTypeDelegate?
    
    private var disposables = CompositeDisposable()
    
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
    
    deinit {
        disposables.dispose()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Grayscale.background
        
        let titleView = ListMapNavigationView()
        navigationItem.titleView = titleView
        titleView.mapButton.addTarget(self, action: #selector(self.switchToMapView(_:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(self.reloadAll(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        
        if !pendingShips.isEmpty {
            let header = PendingShipHeaderView(pendingShips: pendingShips)
            header.delegate = self
            tableView.tableHeaderView = header
        }
        
        view.addSubview(tableView)
        setupConstraints()
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .connectionAdded).observeValues { [unowned self] notification in
            self.refreshShipList()
        }
        
        disposables += NotificationCenter.default.reactive.notifications(forName: .connectionDeleted).observeValues { [unowned self] notification in
            self.showLeftMessage("Successfully deleted connection!", type: .success)
            self.refreshShipList()
        }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0))
        }
    }
    
    private func refreshShipList() {
        self.connectedShips = self.user.ships.filter { !$0.pending }
        self.pendingShips = self.user.ships.filter { $0.pending }
        
        self.tableView.tableHeaderView = nil
        
        if !self.pendingShips.isEmpty {
            let header = PendingShipHeaderView(pendingShips: self.pendingShips)
            header.delegate = self
            self.tableView.tableHeaderView = header
        }
        
        self.tableView.reloadData()
    }
    
    @objc private func reloadAll(_ sender: UIRefreshControl) {
        user.loadShips(success: { _ in
            self.refreshShipList()
            sender.endRefreshing()
        }) { _ in
            self.showLeftMessage("Failed to reload ships, please try again.", type: .error)
            sender.endRefreshing()
        }
    }
    
    // MARK: nav title
    
    @objc private func switchToMapView(_ sender: UIButton?) {
        delegate?.shipControllerDidSwitchToMapView(self)
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
            view.backgroundColor = UIColor.Grayscale.background
            view.detailLabel.font = .avenirDemi(size: 16.0)
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
        cell.layer.cornerRadius = 10.0
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ShipDetailViewController(user: user, ship: connectedShips[indexPath.section])
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: table header view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let header = tableView.tableHeaderView else { return }
        
        header.frame.size.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        tableView.tableHeaderView = header
        tableView.layoutIfNeeded()
    }
    
    // MARK: ship cell delegate
    
    func shipCell(_ cell: ShipTableViewCell, didSelect account: AccountContact, value: String) {
        if let urlStr = account.appUrl(id: value), let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let urlStr = account.webUrl(id: value), let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: pending delegate
    
    func pendingHeaderView(_ view: PendingShipHeaderView, didSelect ship: Ship) {
        guard let coordinate = LocationManager.shared.currentLocation.value?.coordinate else { return }
        
        let viewController = SyncUserPendingViewController(currUser: user, ship: ship, coordinate: coordinate, buttonTitle: "CONFIRM")
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func syncPendingController(_ viewController: SyncUserPendingViewController, didConfirm ship: Ship) {
        refreshShipList()
        self.showLeftMessage("Successfully confirmed \(ship.user.fullName)'s request!", type: .success)
        viewController.dismiss(animated: true, completion: nil)
    }
}
