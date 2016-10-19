//
//  ShiftTableViewCell.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/2/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftTableViewCell: UITableViewCell {

    @IBOutlet weak var outlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outlineView.layer.borderWidth = 0.7
        outlineView.layer.borderColor = MAIN_COLOR.CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
