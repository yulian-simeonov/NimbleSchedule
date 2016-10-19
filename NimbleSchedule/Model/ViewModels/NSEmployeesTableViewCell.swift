//
//  NSEmployeesTableViewCell.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSEmployeesTableViewCell: UITableViewCell {

    let kMargin: CGFloat = 10
    var kButtonWid: CGFloat = 80
    let kButtonHei: CGFloat = 25
    
    var delegate: AnyObject? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buttonWithTitle(title: NSString) -> UIButton {
        
        let button = UIButton.init(frame: CGRectMake(0, 0, kButtonWid, kButtonHei))
        button.setTitle(title as String, forState: UIControlState.Normal)
        button.titleLabel?.font = Utilities.fontWithSize(15.0)
        button.setTitleColor(GRAY_COLOR_3, forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        
        button.setImage(UIImage.init(named: "img_avatar"), forState: .Normal)
        
        return button
    }
    
    func proceedContents(employees: NSArray) {
        kButtonWid = (SCRN_WIDTH - kMargin*4) / 3

        for i in 0...employees.count-1 {
            let button = self.buttonWithTitle("Test Name")
            
            let yPos = CGFloat(19 + Int(i % 3) * Int(kButtonHei + 5))
            let xPos:CGFloat = 19
            var frame = button.frame;
            frame.origin.x = xPos
            frame.origin.y = yPos
            button.frame = frame
            
            if (i == 3) {
                button.backgroundColor = UIColor.whiteColor()
                button.layer.borderWidth = 1.0
                button.layer.borderColor = MAIN_COLOR.CGColor
                button.setTitleColor(MAIN_COLOR, forState: UIControlState.Normal)
                button.setTitle("2 more...", forState: UIControlState.Normal)
                button.addTarget(self, action: "onClickTwoMore:", forControlEvents: UIControlEvents.TouchUpInside)
                self.contentView.addSubview(button)
                
                break
            }
            
            self.contentView.addSubview(button)
        }
    }
    
    func onClickTwoMore(sender: UIButton) {
        print("OnClickTwoMore")
        (self.delegate as! ShiftDetailViewController).showEmployeeListVC()
    }

}
