//
//  ShiftTimingViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol ShiftTimingViewControllerDelegate {
    func didSelectTimes(startDate: NSDate, endDate: NSDate)
}

class ShiftTimingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var timingTable: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    let cellIdentifierArray = ["StartsCell", "EndsCell"]
    
    var selIndexPath: NSIndexPath?
    var startAt: NSDate?
    var endAt: NSDate?
    
    var delegate: ShiftTimingViewControllerDelegate? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selIndexPath = NSIndexPath.init(forRow: 0, inSection: 0)
        self.timingTable.reloadData()
        self.showDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftTiming")
        self.cancelButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Cancel")
        self.doneButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
        self.doneBarButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
    }
    
    func showDatePicker() {
        
        if (selIndexPath?.row == 0) {
            datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        } else {
            datePicker.datePickerMode = UIDatePickerMode.Time
        }
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickDone(sender: AnyObject) {
        
        if (selIndexPath?.row == 0) {
            startAt = datePicker.date
        } else {
            endAt = datePicker.date
        }
        timingTable.reloadData()
    }
    
    @IBAction func onClickAllDone(sender: AnyObject) {
        
        self.delegate?.didSelectTimes(startAt!, endDate: endAt!)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onClickCancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selIndexPath = indexPath
        self.showDatePicker()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellIdentifierArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.cellIdentifierArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        cell.layer.borderWidth = 0.35
        cell.layer.borderColor = GRAY_COLOR_3.CGColor
        
        
        let descLabel = cell.viewWithTag(1) as! UILabel
        let valueLabel = cell.viewWithTag(2) as! UILabel
        
        if (indexPath == selIndexPath) {
            descLabel.textColor = RED_COLOR
        } else {
            descLabel.textColor = GRAY_COLOR_4
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm aa | MMM dd, yyyy"
        
        if (indexPath.row == 0) {
            descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Starts")
            if (startAt == nil) {
                valueLabel.text = ""
            } else {
                valueLabel.text = dateFormatter.stringFromDate(startAt!)
            }
        }
        
        if (indexPath.row == 1) {
            descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Ends")
            dateFormatter.dateFormat = "h:mm aa"
            
            if (endAt == nil) {
                valueLabel.text = ""
            } else {
                valueLabel.text = dateFormatter.stringFromDate(endAt!)
            }
        }
        
        return cell
    }
    
    //--------------------- Header ----------------------------//
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
        headerView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 150, 20))
        descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("SHIFT_TIMINGS")
        descLabel.font = Utilities.boldFontWithSize(12)
        descLabel.textColor = MAIN_COLOR
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        headerView.layer.borderWidth = 0.7
        headerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        return headerView
    }
    
    //------------------- Seperator ----------------//
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    //------------------ Dynamic Cell Height --------------------------//
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
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
