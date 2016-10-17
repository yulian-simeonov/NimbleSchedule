//
//  DashboardViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/9/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import MapKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dashboardTable: UITableView!
    @IBOutlet weak var map : MKMapView!
    @IBOutlet weak var clockInButton: NSRoundButton!
    @IBOutlet weak var upcomingShiftLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
        locValue.latitude = 33.7489954
        locValue.longitude = -84.3879824
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let pin = MKPointAnnotation()
        pin.coordinate = locValue
        map.addAnnotation(pin)
        
        let locationSpan = MKCoordinateSpan.init(latitudeDelta: 100, longitudeDelta: 100)
        var region = MKCoordinateRegionMake(locValue, locationSpan)
        region.span.longitudeDelta = 0.004
        region.span.latitudeDelta = 0.004
        map.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("Dashboard")
        clockInButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("ClockIn"), forState: .Normal)
        upcomingShiftLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("UpcomingShift")
        viewAllButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("ViewAll"), forState: .Normal)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = true
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 70 : 45
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 33
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 1) {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 33))
        headerView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 150, 23))
        descLabel.text = [LocalizeHelper.sharedInstance.localizedStringForKey("OPEN_SHIFTS"), LocalizeHelper.sharedInstance.localizedStringForKey("REQUESTS"), LocalizeHelper.sharedInstance.localizedStringForKey("APPROVALS")][section]
        descLabel.textColor = UIColor.darkGrayColor()
        descLabel.font = Utilities.fontWithSize(12.0)
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        let xPos = tableView.frame.size.width - 80 - 10
        let viewButton = UIButton.init(frame: CGRectMake(xPos, 0, 100, 33))
        viewButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("ViewAll"), forState: UIControlState.Normal)
        viewButton .setTitleColor(MAIN_COLOR, forState: UIControlState.Normal)
        viewButton.titleLabel?.textAlignment = NSTextAlignment.Right
        viewButton.titleLabel?.font = Utilities.fontWithSize(12.0)
        headerView.addSubview(viewButton)
        
        headerView.layer.borderColor = GRAY_COLOR_6.CGColor
        headerView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell!
        if (indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("ShiftCell", forIndexPath: indexPath)
        } else  {
            cell = tableView.dequeueReusableCellWithIdentifier("RightDetailCell", forIndexPath: indexPath)
        }
        return cell
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
