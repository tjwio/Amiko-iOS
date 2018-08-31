//
//  BAProfileViewController.swift
//  Bump
//
//  Created by Tim Wong on 8/30/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BAProfileViewController: UIViewController {
    
    let user: BAUser
    
    let image = MutableProperty<UIImage?>(nil)
    let firstName = MutableProperty<String?>(nil)
    let lastName = MutableProperty<String?>(nil)
    let jobTitle = MutableProperty<String?>(nil)
    let company = MutableProperty<String?>(nil)
    let phone = MutableProperty<String?>(nil)
    let email = MutableProperty<String?>(nil)
    
    let facebook = MutableProperty<String?>(nil)
    let linkedin = MutableProperty<String?>(nil)
    let instagram = MutableProperty<String?>(nil)
    let twitter = MutableProperty<String?>(nil)
    
    init(user: BAUser) {
        self.user = user
        
        image.value = user.image.value
        firstName.value = user.firstName
        lastName.value = user.lastName
        jobTitle.value = user.profession
        company.value = user.company
        phone.value = user.phone
        email.value = user.email
        
        for account in user.socialAccounts {
            switch account.0 {
            case .facebook:
                facebook.value = account.1
            case .linkedin:
                linkedin.value = account.1
            case .instagram:
                instagram.value = account.1
            case .twitter:
                twitter.value = account.1
            default: break
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
}
