//
//  ShiftRepeatViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftRepeatTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
}

class ShiftRepeatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selIndex = 0
    
    @IBOutlet weak var shiftRepatTable: UITableView!
    
    let cellIdentifier = "RepeatCell"
    let repeatTitleArray = [
        LocalizeHelper.sharedInstance.localizedStringForKey("Does_not_repeat"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Daily"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Weekly"),
        LocalizeHelper.sharedInstance.localizedStringForKey("EveryWeekday"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Monthly")]
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.localizeContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftTiming")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selIndex = indexPath.row
        tableView.reloadData()
        
        if (selIndex == 2) { // Weekly Cell
            self.performSegueWithIdentifier(kShowWeeklyRepeatVC, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repeatTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        (cell as! ShiftRepeatTableCell).titleLabel.text = repeatTitleArray[indexPath.row]
        
        
        if (indexPath.row == selIndex) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell.layer.borderWidth = 0.35
        cell.layer.borderColor = GRAY_COLOR_3.CGColor
        
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
        descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("REPEAT")
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
