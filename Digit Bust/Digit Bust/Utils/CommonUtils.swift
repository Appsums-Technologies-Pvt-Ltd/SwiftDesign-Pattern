//
//  CommonUtils.swift
//  Krepta
//
//  Created by Beautistar on 12/06/2017.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import Foundation


func isValidEmail(testStr:String) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
    
}

