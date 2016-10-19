//
//  SelectRequestTypeViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 12/4/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class SelectRequestTypeViewController: UIViewController {

    private let cellIdentifier = "RequestsCell"
    
    @IBOutlet weak var requestTypeTable: UITableView!
    
    var selIndex = 0
    
    let repeatTitleArray = [LocalizeHelper.sharedInstance.localizedStringForKey("Swap_Trade"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Shift_drop"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Cover_request"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Time_off"),
        LocalizeHelper.sharedInstance.localizedStringForKey("Pick_up_open_shift")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selIndex = indexPath.row
        
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier(kShowSwapTradeRequestVC, sender: self)
            break
        case 1:
            self.performSegueWithIdentifier(kShowShiftDropRequestVC, sender: self)
            break
        case 2:
            self.performSegueWithIdentifier(kShowCoverRequestVC, sender: self)
            break
        case 3:
            self.performSegueWithIdentifier(kShowTimeOffRequestVC, sender: self)
            break
        case 4:
            self.performSegueWithIdentifier(kShowPickUpOpenShiftRequestVC, sender: self)
            break
        default:
            break
        }

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
        descLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("WHAT_TYPE_OF_REQUEST_IS_THIS")
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
    
    // MARK: - UIButtonAction
    @IBAction func onClickClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == kShowSwapTradeRequestVC) {
            let destVC = segue.destinationViewController as! SwapTradeRequestViewController
            destVC.requestType = ERequestType(rawValue: selIndex)!
        }
    }
}
