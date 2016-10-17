//
//  CoverRequestViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/7/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class CoverRequestViewController: UIViewController, SelectEmployeeViewControllerDelegate, ScheduleViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var requestType = ERequestType.SwapTrade
    
    var sectionTitleArray = []
    var identifierArray = []
    var cellHeiArray = []
    var stepNo = 0
    
    @IBOutlet weak var requestTypeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self .updateTableContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("CreateRequest")
    }
    
    // MARK: - UpdateTableContent
    func updateTableContent() {
        if (stepNo == 0) {
            sectionTitleArray = [LocalizeHelper.sharedInstance.localizedStringForKey("PICK_A_SHIFT")]
            identifierArray = ["ShiftPickUpCell"]
            cellHeiArray = [60]
        } else if (stepNo == 1) {
            sectionTitleArray = [LocalizeHelper.sharedInstance.localizedStringForKey("PICK_A_SHIFT"), LocalizeHelper.sharedInstance.localizedStringForKey("WHO_DO_YOU_WANT_TO_COVER_FOR_YOU")]
            identifierArray = ["ShiftDetailCell", "SelectEmployeeCell"]
            cellHeiArray = [85, 60]
        } else if (stepNo == 2) {
            sectionTitleArray = [LocalizeHelper.sharedInstance.localizedStringForKey("PICK_A_SHIFT"), LocalizeHelper.sharedInstance.localizedStringForKey("WHO_DO_YOU_WANT_TO_COVER_FOR_YOU"), LocalizeHelper.sharedInstance.localizedStringForKey("ENTER_A_MESSAGE")]
            identifierArray = ["ShiftDetailCell", "EmployeeDetailCell", "MessageCell"]
            cellHeiArray = [85, 80, 130]
        }
        self.requestTypeTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (stepNo == 0 && indexPath.section == 0) {
            self.performSegueWithIdentifier(kShowSelectShiftVC, sender: self)
        } else if (stepNo == 1 && indexPath.section == 1) {
            self.performSegueWithIdentifier(kShowSelectEmployeeVC, sender: self)
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = identifierArray[indexPath.section] as! String
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        cell.layer.borderWidth = 0.35
        cell.layer.borderColor = GRAY_COLOR_3.CGColor
        
        return cell
    }
    
    //--------------------- Fotter, Header ----------------------------//
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 25))
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
        headerView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, tableView.frame.size.width-20, 20))
        descLabel.text = sectionTitleArray[section] as? String
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
        return cellHeiArray[indexPath.section] as! CGFloat
    }
    
    // MARK: - UIButtonAction
    @IBAction func onClickClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    // MARK: - ScheduleViewControllerDelegate
    func shiftDidSelect(shiftObj: NSShift) {
        stepNo = 1
        self.updateTableContent()
    }
    
    // MARK: - SelectEmployeeViewControllerDelegate
    func employeeDidSelect(shiftObj: NSShift) {
        stepNo = 2
        self.updateTableContent()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == kShowSelectShiftVC) {
            let destVC = segue.destinationViewController as! ScheduleViewController
            destVC.isFromRequest = true
            destVC.requestDelegate = self
        } else if (segue.identifier == kShowSelectEmployeeVC) {
            let destVC = segue.destinationViewController as! SelectEmployeeViewController
            destVC.delegate = self
        }
    }

}
