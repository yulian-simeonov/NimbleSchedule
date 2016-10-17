//
//  ClockInAsViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/19/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ClockInAsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}

class ClockInAsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var positionTable: UITableView!
    @IBOutlet weak var tableHeiConstraint: NSLayoutConstraint!
    
    private let cellIdentifier = "ClockInAsCell"
    
    var positionArray = []
    var clockInDate: NSDate!
    var selIndex = 0
    var clockInId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        positionTable.layer.borderColor = GRAY_COLOR_3.CGColor
        positionTable.layer.borderWidth = 0.7
        
        let tblView =  UIView(frame: CGRectZero)
        positionTable.tableFooterView = tblView
        positionTable.tableFooterView!.hidden = true
        positionTable.backgroundColor = UIColor.clearColor()
        
        tableHeiConstraint.constant = 65 + 45*6
        NSAPIClient.sharedInstance.getPositionList { (nsData, error) -> Void in
//            print(nsData)
            if (error == nil) {
                self.positionArray = nsData!["data"] as! NSArray
                self.positionTable.reloadData()
            }
        }
        
//        NSAPIClient.sharedInstance.getPositionListWithEmployeeId(SharedDataManager.sharedInstance.employeeId) { (nsData, error) -> Void in
//            print(nsData)
//            if (error == nil) {
//                self.positionArray = nsData!["data"] as! NSArray
//                self.positionTable.reloadData()
//            }
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ClockIn")
    }
    
    // Mark: - UITableViewDelegate, UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selIndex = indexPath.row
        
        self.performSegueWithIdentifier(kShowClockOutVC, sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 65))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let descLabel = UILabel.init(frame: CGRectMake(20, 5, 300, 55))
        descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Clocking_in_as")
        descLabel.font = Utilities.fontWithSize(23)
        descLabel.textColor = UIColor.blackColor()
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        headerView.layer.borderWidth = 0.7
        headerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ClockInAsCell
        
        let positionDict = positionArray[indexPath.row] as! NSDictionary
        
        cell.titleLabel.text = Utilities.getValidString(positionDict["name"] as? String, defaultString: "None")
        
        return cell
    }

    //------------------- Seperator ----------------//
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == kShowClockOutVC) {
            let destVC = segue.destinationViewController as! ClockOutViewController
            destVC.clockInDate = clockInDate

            let positionDict = positionArray[selIndex] as! NSDictionary
            destVC.positionDict = positionDict
            destVC.clockInId = self.clockInId
        }
    }

}
