//
//  RequestsViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, WSExpandTableViewDataSource, WSExpandTableViewDelegate, UITableViewDataSource, UITableViewDelegate {

    private let cellIdentifier = "SwapCell"
    
    var cellIdentifierArray = ["RequestDeclineCell", "TradeApproveCell", "TradeAcceptCell", "CoverRequestCell"]
    
    @IBOutlet weak var requestsTable: WSExpandTableView!
    @IBOutlet weak var activityTable: UITableView!
    
    @IBOutlet weak var requestSegment: UISegmentedControl!
    @IBOutlet var unreadView: UIView!
    @IBOutlet var activityView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.requestsTable.WSExpandTableViewDataSource = self
        self.requestsTable.WSExpandTableViewDelegate = self
        
        self.buildScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Functions
    func buildScrollView() {
        
        let hei = SCRN_HEIGHT - 64 - 45
        scrollView.contentSize = CGSizeMake(SCRN_WIDTH * 2, hei)
        scrollView.subviews.forEach {$0.removeFromSuperview()}
        
        var frame = unreadView.frame
        frame.origin = CGPointMake(0, 0)
        frame.size.height = hei
        unreadView.frame = frame
        
        frame.origin = CGPointMake(SCRN_WIDTH, 0)
        activityView.frame = frame
        
        scrollView.addSubview(unreadView)
        scrollView.addSubview(activityView)
    }
    
    // MARK: - On Segment Change
    @IBAction func onSegmentChange(sender: AnyObject) {
        
        self.scrollView.setContentOffset(CGPointMake(self.scrollView.bounds.size.width * CGFloat(requestSegment.selectedSegmentIndex), 0), animated: true)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierArray[indexPath.row], forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.heightWithCellAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        headerView.backgroundColor = UIColor.clearColor()
        
        let dateButton = UIButton.init(type: .Custom)
        dateButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        dateButton.backgroundColor = GRAY_COLOR_3
        dateButton.frame = CGRectMake(15, 10, 84, 30)
        dateButton.setTitle("Today", forState: .Normal)
        headerView.addSubview(dateButton)
        
        return headerView
    }
    
    // MARK: - WSExpandTableViewDataSource, WSExpandTableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == activityTable) {
            return section == 0 ? 1 : 4
        }
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (tableView == activityTable) {
            return 2
        }
        return 4
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!, isExpanded: Bool) -> CGFloat {
        
        if (isExpanded) {
            return 226
        }
        return 58
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 15))
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView!, expandCell cell: UITableViewCell!, withIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func tableView(tableView: UITableView!, collapseCell cell: UITableViewCell!, withIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, isExpanded: Bool) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        let name = cell?.contentView.viewWithTag(1) as? UILabel
        let userImage = cell?.contentView.viewWithTag(2) as? UIImageView
        
        let period = SharedDataManager.sharedInstance.temporaryData.objectAtIndex(indexPath.section) as! NSSchedulePeriod
        name?.text = period.employeeName
        userImage?.sd_setImageWithURL(NSURL.init(string: period.employeePhoto))
        
        
        return cell
    }
    
    // MARK: - UITableView Calc Height
    func heightWithCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        var sizingCell: UITableViewCell!
        var onceToken: dispatch_once_t = 0
        let identifier = cellIdentifierArray[indexPath.row]
        dispatch_once(&onceToken) { () -> Void in
            sizingCell = self.activityTable.dequeueReusableCellWithIdentifier(identifier)
        }
        //        if (identifier == "NotesCell") {
        //            (sizingCell as! NSBasicTableViewCell).subtitleLabel?.text = "Test test set Test test set Test test set Test test set Test test set asdfasdfasdfasdfasdfasdfasdfasdfasdf"
        //        }
        return self.calculateHeightForConfiguredSizingCell(sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        
        sizingCell.bounds = CGRectMake(0, 0, SCRN_WIDTH, CGRectGetHeight(sizingCell.bounds))
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size: CGSize = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height + 1
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
