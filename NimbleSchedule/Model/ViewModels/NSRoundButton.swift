       //
//  NSRoundButton.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/27/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSRoundButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        self.layer.cornerRadius = 0.01*self.bounds.size.width
    }
}
    

