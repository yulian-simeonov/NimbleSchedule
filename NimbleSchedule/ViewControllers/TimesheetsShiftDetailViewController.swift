//
//  TimesheetsShiftDetailViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 1/4/16.
//
//

import UIKit

class TimesheetsShiftDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var cellIdentifiers = []
    var sectionTitleArray = []
    
    
    @IBOutlet weak var shiftDetailTable: UITableView!
    @IBOutlet weak var shiftStatusLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
            cellIdentifiers = ["DetailCell", "NotesCell"]
            sectionTitleArray = ["TIMINGS", "SHIFT NOTES"]
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.shiftDetailTable.reloadData()
            self.shiftDetailTable.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        }
        self.shiftDetailTable.reloadData()
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
        
        if section == 1 {
            let moreButton = UIButton.init(frame: CGRectMake(tableView.frame.size.width - 50, 0, 50, 32))
            moreButton.setImage(UIImage.init(named: "ico-pencil"), forState: .Normal)
            newView.addSubview(moreButton)
        }
        
        return newView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var height: CGFloat!
        if ((cellIdentifiers[indexPath.section] as! String) == "DetailCell") {
            height = 80
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
        
        if (cellIdentifier == "NotesCell") {
            (cell as! NSBasicTableViewCell).subtitleLabel?.text = "Meeting delayed by 15 mins"
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
            (sizingCell as! NSBasicTableViewCell).subtitleLabel?.text = "Meeting delayed by 15 mins"
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

}
