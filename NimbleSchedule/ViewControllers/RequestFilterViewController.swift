//
//  RequestFilterViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 12/1/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class RequestTypeTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        if (selected) {
            self.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            self.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
}

class RequestFilterViewController: UIViewController {

    private let cellIdentifier = "RequestsCell"
    
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var selectedIndexPathArray: NSMutableArray = []
    var selIndex = 0
    
    let repeatTitleArray = [
        LocalizeHelper.sharedInstance.localizedStringForKey("Swap_Trade"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Shift_drop"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Cover_request"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Time_off"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Pick_up_open_shift")]

    @IBOutlet weak var requestFilterTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedIndexPathArray = NSMutableArray()
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
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("Set_Filters")
        selectAllButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("SELECT_ALL"), forState: .Normal)
        applyButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("APPLY"), forState: .Normal)
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickSelectAll(sender: AnyObject) {
        selectedIndexPathArray.removeAllObjects()
        for i in 0...repeatTitleArray.count-1 {
            selectedIndexPathArray.addObject(NSIndexPath.init(forRow: i, inSection: 0))
            requestFilterTable.selectRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
    }
    
    @IBAction func onClickApply(sender: AnyObject) {
    }
    
    @IBAction func onClickClose(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (selectedIndexPathArray.containsObject(indexPath)) {
            selectedIndexPathArray.removeObject(indexPath)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            selectedIndexPathArray.addObject(indexPath)
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        selIndex = indexPath.row
//        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repeatTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        (cell as! RequestTypeTableCell).titleLabel.text = repeatTitleArray[indexPath.row]
        
        
        
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
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, tableView.frame.size.width-20, 20))
        descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("SHOW_REQUESTS_OF_TYPE")
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
