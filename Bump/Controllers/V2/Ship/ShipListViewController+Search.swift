//
//  ShipListViewController+Search.swift
//  Bump
//
//  Created by Tim Wong on 7/23/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

extension ShipListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), !text.isEmpty else {
            pendingShips = user.ships.filter { $0.pending }
            connectedShips = user.ships.filter { !$0.pending }
            tableView.reloadData()
            return
        }
        
        pendingShips = user.ships.filter { $0.pending && ($0.user.fullName.lowercased().contains(text) || $0.user.publicBio.contains(text)) }
        connectedShips = user.ships.filter { !$0.pending && ($0.user.fullName.lowercased().contains(text) || $0.user.publicBio.contains(text)) }
        tableView.reloadData()
    }
    
}
