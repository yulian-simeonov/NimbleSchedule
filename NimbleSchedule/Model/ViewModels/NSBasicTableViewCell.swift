//
//  NSBasicTableViewCell.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/12/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSBasicTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
