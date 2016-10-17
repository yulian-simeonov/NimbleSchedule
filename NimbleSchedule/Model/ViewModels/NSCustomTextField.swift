//
//  PaddingTextField.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/21/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSCustomTextField: UITextField {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let paddingView = UIView(frame: CGRectMake(0, 0, 5, 20))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.Always
        
        self.layer.cornerRadius = 0.01 * self.bounds.size.width
        
        self .clearRedOutLine()
    }
    
    func drawRedOutLine() {
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 1.0
    }

    func clearRedOutLine() {
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
    func checkInputText() -> Bool {
        if (Utilities.isValidData(self.text)) {
            self.clearRedOutLine()
            return true
        } else {
            self.drawRedOutLine()
            return false
        }
    }
}
