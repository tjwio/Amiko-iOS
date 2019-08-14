//
//  TextFieldTableViewViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/13/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit

protocol TextFieldTableViewKeyboardShowable {
    var isEmbedded: Bool { get set }
    var bottomOffset: CGFloat? { get set }
    var origContentInset: UIEdgeInsets? { get set }
    
    var tableView: UITableView { get }
    
    func updateOrigContentInset(_ origContentInset: UIEdgeInsets?)
    
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}

extension TextFieldTableViewKeyboardShowable where Self: UIViewController {
    func keyboardWillShow(_ notification: Notification) {
        if self.navigationController?.viewControllers.last === self || (self.isEmbedded && self.navigationController?.viewControllers.last === self.parent?.parent) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0.0, bottom: keyboardSize.height + (self.bottomOffset ?? 0.0), right: 0.0)
                
                updateOrigContentInset(self.tableView.contentInset)
                
                UIView.animate(withDuration: (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.tableView.contentInset = contentInsets
                    self.tableView.scrollIndicatorInsets = contentInsets
                    self.tableView.setNeedsDisplay()
                }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if self.navigationController?.viewControllers.last === self || (self.isEmbedded && self.navigationController?.viewControllers.last === self.parent?.parent) {
            UIView.animate(withDuration: (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3, animations: {
                if let contentInset = self.origContentInset {
                    self.tableView.contentInset = contentInset
                    self.tableView.scrollIndicatorInsets = contentInset
                }
            })
        }
    }
}

class TextFieldTableViewController: UIViewController, TextFieldTableViewKeyboardShowable {
    
    var isEmbedded = false
    var bottomOffset: CGFloat?
    var origContentInset: UIEdgeInsets?
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNormalMagnitude))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: keyboard notifications
    
    func updateOrigContentInset(_ origContentInset: UIEdgeInsets?) {
        self.origContentInset = origContentInset
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        keyboardWillShow(notification)
    }
    
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        keyboardWillHide(notification)
    }
}
