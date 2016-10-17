//
//  WeekShiftTableViewCell.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/3/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class WeekShiftTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var shiftCollectionView: UICollectionView!
    
    private let cellIdentifier = "WeeklyShiftCollection"
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 1.5)
    
    var shifts = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        dayLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
//        dayLabel.layer.borderWidth = 1.5
//        dayLabel.clipsToBounds = true

        let border = Utilities.createBorder(edge: UIRectEdge.Right, colour: UIColor.lightGrayColor(), thickness: 1.5, frame: dayLabel.frame)
        dayLabel.layer.addSublayer(border)
    }

    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if (selected) {
            self.dayLabel.backgroundColor = MAIN_COLOR
        } else {
            self.dayLabel.backgroundColor = GRAY_COLOR_4
        }
    }
  
    
    func proceedContents(dateObj: NSDate! , shifts : NSMutableArray) {
        self.shiftCollectionView.registerNib(UINib.init(nibName: "WeeklyShiftCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: cellIdentifier)

        let calendar = NSCalendar.currentCalendar()
        let day = calendar.daysInDate(dateObj)
        let dayName = dateObj.dayNameOnCalendar(calendar)
        
        let dayStr = NSMutableAttributedString.init(string: "\(day)\n\(dayName)")
//        dayStr.appendAttributedString(NSAttributedString.init(string: "\n"))
//        
//        dayStr.appendAttributedString(NSAttributedString.init(string: "Mon"))
        self.shifts = shifts
        dayLabel.attributedText = dayStr
        
        self.shiftCollectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.shifts.count
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
   
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        // Configure the cell
        
        let colorView = cell.contentView.viewWithTag(1)! as UIView
        let location = cell.contentView.viewWithTag(2) as? UILabel
        let position = cell.contentView.viewWithTag(3) as? UILabel
        let time = cell.contentView.viewWithTag(4) as? UILabel
        
       
        let period = self.shifts.objectAtIndex(indexPath.section) as! NSSchedulePeriod
        
        colorView.backgroundColor = Utilities.colorWithHexString(period.color)
        location?.text = period.locationName
        position?.text = period.positionName
        time?.text = "\(Utilities.convertPeriodHours((period.startAt!)))-\(Utilities.convertPeriodHours((period.endAt)!))"
        cell.contentView.backgroundColor = Utilities.colorWithHexString("e5ffff")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
