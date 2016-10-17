//
//  NSBtmTitleButton.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/10/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSBtmTitleButton: UIButton {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.centerImageAndTitle()
    }

    func centerImageAndTitle(spacing: CGFloat) {
        let imageSize = self.imageView?.frame.size
        let titleSize = self.titleLabel?.frame.size
        
        let totalHei = imageSize!.height + titleSize!.height + spacing
        self.imageEdgeInsets = UIEdgeInsetsMake(imageSize!.height - totalHei, 0.0, 0.0, -1 * titleSize!.width)
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -1 * imageSize!.width, titleSize!.width - totalHei, 0.0)
    }
    
    func centerImageAndTitle() {
        let DEFAULT_SPACING: CGFloat = 6.0
        self.centerImageAndTitle(DEFAULT_SPACING)
    }
}
