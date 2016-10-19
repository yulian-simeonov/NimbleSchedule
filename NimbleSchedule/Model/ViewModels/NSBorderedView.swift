//
//  NSBorderedView.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/19/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSBorderedView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.borderWidth = 0.7
        self.layer.borderColor = GRAY_COLOR_3.CGColor
    }

}
