//
//  BACommonUtility.swift
//  Bump
//
//  Created by Tim Wong on 4/15/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

class BACommonUtility: NSObject {
    public class func isValidEmail(_ email: String!) -> Bool {
        if (email.count > 0) {
            let laxChecker = "^.+@.+.[A-Za-z]{2}[A-Za-z]*$";
            
            let emailTest = NSPredicate(format: "SELF MATCHES %@", laxChecker);
            return emailTest.evaluate(with: email);
        }
        
        return false;
    }
}
