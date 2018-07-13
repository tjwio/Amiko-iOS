//
//  BAFirstExpIntroViewController.swift
//  Bump
//
//  Created by Tim Wong on 7/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BAFirstExpIntroViewController: UIViewController {
    
    private struct Constants {
        static let titleFontSize: CGFloat = 44.0
        static let detailFontSize: CGFloat = 18.0
        static let swipeFontSize: CGFloat = 16.0
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = BAStrings.Global.title.localized
        label.textColor = UIColor.Grayscale.dark
        label.font = UIFont.avenirBold(size: Constants.titleFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = BAStrings.FirstExp.introDescription.localized
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirMedium(size: Constants.detailFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let swipeLabel: UILabel = {
        let label = UILabel()
        label.text = BAStrings.FirstExp.swipeLeft.localized.uppercased()
        label.textColor = UIColor.Grayscale.light
        label.font = UIFont.avenirDemi(size: Constants.swipeFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Grayscale.lightest
        
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(swipeLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.detailLabel.snp.bottom).offset(-6.0)
            make.centerX.equalTo(self.view)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        swipeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-32.0)
            make.centerX.equalTo(self.view)
        }
    }
}
