//
//  ShiftDetailViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/12/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var isOpenShift: Bool = false
    var cellIdentifiers = []
    var assignedEmployees = []
    var sectionTitleArray = []
    
    
    @IBOutlet weak var shiftDetailTable: UITableView!
    @IBOutlet weak var pickUpButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (self.isOpenShift) {
            cellIdentifiers = ["LocationCell", "RepeatsCell", "NotesCell"]
            sectionTitleArray = [
                "",
                LocalizeHelper.sharedInstance.localizedStringForKey("REPEATS"),
                LocalizeHelper.sharedInstance.localizedStringForKey("NOTES")
            ]
        } else {
            cellIdentifiers = ["LocationCell", "RepeatsCell", "EmployeesCell", "NotesCell"]
            sectionTitleArray = [
                "",
                LocalizeHelper.sharedInstance.localizedStringForKey("REPEATS"),
                LocalizeHelper.sharedInstance.localizedStringForKey("OPEN_SHIFTS"),
                LocalizeHelper.sharedInstance.localizedStringForKey("NOTES")
            ]
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.shiftDetailTable.reloadData()
            self.shiftDetailTable.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        }
        
        assignedEmployees = ["Test", "Test", "Test", "Test", "Test", "Test", "Test"]
        self.shiftDetailTable.reloadData()
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        pickUpButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("PickUpShift"), forState: .Normal)
    }
    
    // Mark: - UIButtonAction
    @IBAction func onClickEdit(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func onClickClose(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0) {
            return 0
        }
        return 32
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if ((cellIdentifiers[section] as! String) == "EmployeesCell") {
            return 10
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let newView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        newView.backgroundColor = UIColor.whiteColor()
        
        return newView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return cellIdentifiers.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((cellIdentifiers[section] as! String) == "EmployeesCell")
        {
            return assignedEmployees.count > 3 ? 3 : assignedEmployees.count
        }
        return 1
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let newView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 32))
        newView.backgroundColor = GRAY_COLOR_5
        newView.layer.borderColor = GRAY_COLOR_6.CGColor
        newView.layer.borderWidth = 0.6
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 0, 150, 32))
        descLabel.text = sectionTitleArray[section] as? String
        descLabel.font = Utilities.fontWithSize(13)
        descLabel.textColor = GRAY_COLOR_3
        descLabel.backgroundColor = UIColor.clearColor()
        newView .addSubview(descLabel)
        
        if ((cellIdentifiers[section] as! String) == "EmployeesCell")
        {
            if (self.assignedEmployees.count > 3) {
                let moreButton = UIButton.init(frame: CGRectMake(tableView.frame.size.width - 100, 0, 100, 32))
                moreButton.titleLabel?.font = Utilities.fontWithSize(14)
                moreButton.setTitleColor(MAIN_COLOR, forState: .Normal)
                moreButton.setTitle("+ \(self.assignedEmployees.count - 3) \(LocalizeHelper.sharedInstance.localizedStringForKey("more"))", forState: .Normal)
                newView.addSubview(moreButton)
            }
        }
        
        return newView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var height: CGFloat!
        if ((cellIdentifiers[indexPath.section] as! String) == "EmployeesCell")
        {
            height = indexPath.row == 0 ? 45 : 35
        } else if ((cellIdentifiers[indexPath.section] as! String) == "LocationCell") {
            height = 64
        } else {
            height = self.heightWithCellAtIndexPath(indexPath)
        }
        return height
    }
    
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = cellIdentifiers[indexPath.section] as! String
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if (cellIdentifier == "RepeatsCell") {
            (cell as! NSBasicTableViewCell).subtitleLabel?.text = "Thursday, Friday, Saturday & Monday"
        } else if (cellIdentifier == "NotesCell") {
            (cell as! NSBasicTableViewCell).subtitleLabel?.text = "Meeting delayed by 15 minutes"
        } else if (cellIdentifier == "EmployeesCell") {
            let employeesCell = cell as! NSEmployeesTableViewCell
        }
        
        return cell
    }
    
    // MARK: - UITableView Calc Height
    func heightWithCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        var sizingCell: UITableViewCell!
        var onceToken: dispatch_once_t = 0
        let identifier = cellIdentifiers[indexPath.section] as! String
        dispatch_once(&onceToken) { () -> Void in
            sizingCell = self.shiftDetailTable.dequeueReusableCellWithIdentifier(identifier)
        }
        if (identifier == "NotesCell") {
            (sizingCell as! NSBasicTableViewCell).subtitleLabel?.text = "Meeting delayed by 15 minutes"
        }
        return self.calculateHeightForConfiguredSizingCell(sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        
        sizingCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.shiftDetailTable.frame), CGRectGetHeight(sizingCell.bounds))
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size: CGSize = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height + 1
    }
    
    // MARK: - Page Navigation
    func showEmployeeListVC() {
        
        self.performSegueWithIdentifier(kShowEmployeeListVC, sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
