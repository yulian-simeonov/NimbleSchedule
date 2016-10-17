//
//  ShiftLocationViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftLocationTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
}

protocol ShiftLocationViewControllerDelegate {
    func locationDidSelect(locationObj: NSLocation)
}

class ShiftLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let cellIdentifier = "LocationCell"
    
    var locationArray = NSMutableArray()
    var delegate: ShiftLocationViewControllerDelegate? = nil
    
    @IBOutlet weak var shiftLocationTable: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.show()
        NSAPIClient.sharedInstance.getLocationList { (nsData, error) -> Void in
            print(nsData)
            SVProgressHUD.dismiss()
            
            if (error == nil) {
                self.locationArray.removeAllObjects()
                for locationDict in nsData!["data"] as! NSArray {
                    let locationObj = NSLocation.initWithDictionary(locationDict as! NSDictionary)
                    if (locationObj != nil) {
                        self.locationArray.addObject(locationObj!)
                    }
                }
                self.shiftLocationTable.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftLocation")
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (self.delegate?.locationDidSelect(self.locationArray[indexPath.row] as! NSLocation)) != nil {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let locationObj = locationArray[indexPath.row] as! NSLocation
        (cell as! ShiftLocationTableCell).titleLabel.text = locationObj.name
        
        return cell
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
        
        return 60
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
