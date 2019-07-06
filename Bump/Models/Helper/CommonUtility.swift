//
//  BACommonUtility.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import GSMessages

class CommonUtility: NSObject {
    public class func isValidEmail(_ email: String!) -> Bool {
        if (email.count > 0) {
            let laxChecker = "^.+@.+.[A-Za-z]{2}[A-Za-z]*$";
            
            let emailTest = NSPredicate(format: "SELF MATCHES %@", laxChecker);
            return emailTest.evaluate(with: email);
        }
        
        return false;
    }
    
    public class func configureMessages() {
        if let font = UIFont.avenirDemi(size: 16.0) {
            GSMessage.font = font
        }
        GSMessage.successBackgroundColor = UIColor.Green.normal
        GSMessage.warningBackgroundColor = UIColor.Yellow.normal
        GSMessage.errorBackgroundColor   = UIColor.Red.normal
    }
}
