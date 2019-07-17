//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 9/26/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAProfileViewController: ProfileBaseViewController {
    let logOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.Red.normal, for: .normal)
        button.setTitleColor(UIColor.Red.darker, for: .normal)
        button.titleLabel?.font = UIFont.avenirDemi(size: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let dummyHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dummyShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.addTarget(self, action: #selector(self.logOut(_:)), for: .touchUpInside)
        
        profileView.isHidden = false
        profileView.transform = CGAffineTransform(translationX: 0.0, y: view.frame.size.height)
        profileView.cancelButton.addTarget(self, action: #selector(self.cancelProfileView(_:)), for: .touchUpInside)
        profileView.tableView.tableFooterView = getTableFooterView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(_:)))
        panGestureRecognizer.delegate = self
        dummyHeaderView.addGestureRecognizer(panGestureRecognizer)
        
        profileView.insertSubview(dummyHeaderView, at: 0)
        view.addSubview(dummyShadowView)
        dummyShadowView.addSubview(profileView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(hexColor: 0xA7ADB6, alpha: 0.60);
            
            self.profileView.transform = .identity
            self.dummyShadowView.layer.applySketchShadow(color: UIColor(hexColor: 0x3D3F42), alpha: 0.40, x: 0.0, y: 1.0, blur: 12.0, spread: 0.0)
        }, completion: nil)
    }
    
    private func setupConstraints() {
        dummyShadowView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(40.0)
            make.leading.equalTo(self.view).offset(12.0)
            make.trailing.equalTo(self.view).offset(-12.0)
            make.bottom.equalTo(self.view).offset(6.0)
        }
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dummyHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(profileView.tableView.snp.top)
        }
    }
    
    override func dismissViewController() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = .clear
            self.profileView.transform = CGAffineTransform(translationX: 0.0, y: self.view.frame.size.height)
        }) { completed in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: cancel
    
    @objc private func cancelProfileView(_ sender: UIButton?) {
        dismissViewController()
    }
    
    //MARK: log out
    
    @objc private func logOut(_ sender: UIButton?) {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            DispatchQueue.main.async {
                AppManager.shared.logOut()
            }
        }
        
        alertController.addAction(cancel)
        alertController.addAction(logOut)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func getTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: profileView.tableView.bounds.size.width, height: 100.0))
        
        footerView.addSubview(logOutButton)
        
        logOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return footerView
    }
    
    // MARK: pan gesture recognizer
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if originalProfileFrame == nil { originalProfileFrame = profileView.frame }
        }
        else if sender.state == .changed {
            guard let minFrame = originalProfileFrame else { return }
            
            let translatedPoint = sender.translation(in: profileView)
            let newY = profileView.frame.origin.y + translatedPoint.y
            profileView.frame.origin.y = max(newY, minFrame.minY)
            
            sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: profileView)
        }
        else if sender.state == .ended {
            let velocity = sender.velocity(in: profileView)
            
            if velocity.y > 500 || profileView.frame.minY > view.frame.midY {
                dismissViewController()
            }
            else {
                UIView.animate(withDuration: 0.25) {
                    self.profileView.frame.origin.y = self.originalProfileFrame?.minY ?? 20.0
                }
            }
        }
    }
}
