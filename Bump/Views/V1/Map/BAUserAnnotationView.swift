//
//  BAUserAnnotationView.swift
//  Bump
//
//  Created by Tim Wong on 8/8/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class BAUserAnnotationView: MKAnnotationView {
    
    let userImageView = BAAvatarView()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userImageView)
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        userImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        super.updateConstraints()
    }
}
