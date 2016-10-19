//
//  MonthCalendarCollectionViewCell.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/8/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class MonthCalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var btmBorder: UIView!
    @IBOutlet weak var rightBorder: UIView!
    
    var dayNumber: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dayLabel.layer.cornerRadius = 13.5
        self.dayLabel.layer.masksToBounds = true
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                if (self.dayNumber == Utilities.getDay(NSDate())) {
                    self.makeTodayCell()
                } else {
                    self.makeCellSelected()
                }
            } else if newValue == false {
                super.selected = false
                self.makeNormalCell()
            }
        }
    }
    
    func makeCellSelected() {
        self.dayLabel.textColor = UIColor.whiteColor()
        self.dayLabel.backgroundColor = GRAY_COLOR_3
    }
    
    func makeTodayCell() {
        self.dayLabel.textColor = UIColor.whiteColor()
        self.dayLabel.backgroundColor = MAIN_COLOR
    }
    
    func makeNormalCell() {
        self.dayLabel.textColor = GRAY_COLOR_3
        self.dayLabel.backgroundColor = UIColor.clearColor()
    }
}
