//
//  EditLocAndPosViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 12/17/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol EditLocAndPosViewControllerDelegate {
    func locAndPosDidEdit(positionDict: NSDictionary)
}

class EditLocAndPosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShiftLocationViewControllerDelegate, SelectPositionViewControllerDelegate {
    
    @IBOutlet weak var employeesTable: UITableView!
    
    let cellIdentifierArray = ["PersonalInfoCell", "ContactInfoCell"]
    
    var delegate: EditLocAndPosViewControllerDelegate? = nil
    var positionArray = NSMutableArray()
    var locationData: NSLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.employeesTable.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickDone(sender: AnyObject) {
        if (locationData != nil) {
            if self.delegate?.locAndPosDidEdit(["Location": locationData!, "Position": positionArray]) != nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else {
            Utilities.showMsg("Add location first!", delegate: self)
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 1) {
            if cell.respondsToSelector("setSeparatorInset:") {
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
            }
            if cell.respondsToSelector("setLayoutMargins:") {
                cell.layoutMargins = UIEdgeInsetsZero
            }
            if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
                cell.preservesSuperviewLayoutMargins = true
            }
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 0) {
            self.performSegueWithIdentifier(kShowShiftLocationVC, sender: self)
        } else if (indexPath.section == 1) {
            if positionArray.count == indexPath.row {
                self.performSegueWithIdentifier(kShowSelectPositionVC, sender: self)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : positionArray.count > 0 ? positionArray.count+1 : locationData == nil ? 0 : 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return locationData == nil ? 1 : 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if positionArray.count != indexPath.row {
                return 35
            }
        }
        return 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 33))
        headerView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 250, 23))
        descLabel.text = ["SELECT A LOCATION", "ADD A POSITION"][section]
        descLabel.textColor = UIColor.darkGrayColor()
        descLabel.font = Utilities.fontWithSize(12.0)
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        headerView.layer.borderColor = GRAY_COLOR_6.CGColor
        headerView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "SelectLocationCell"
        
        if indexPath.section == 0 {
            cellIdentifier = locationData == nil ? "SelectLocationCell" : "LocationCell"
        } else if indexPath.section == 1 {
            if positionArray.count == indexPath.row {
                cellIdentifier = positionArray.count == 0 ? "SelectPositionsCell" : "AddAnotherCell"
            } else {
                cellIdentifier = "PositionCell"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            if locationData != nil {
                (cell as! NSBasicTableViewCell).subtitleLabel.text = locationData?.name
            }
        } else if indexPath.section == 1 && indexPath.row < positionArray.count {
            if (cell.isKindOfClass(PositionTableCell)) {
                let position = positionArray[indexPath.row] as! NSPosition
                
                let positionCell = cell as! PositionTableCell
                
                positionCell.closeButton.addTarget(self, action: Selector("onClickClose:"), forControlEvents: .TouchUpInside)
                positionCell.closeButton.tag = indexPath.row
                
                positionCell.statusButton.backgroundColor = position.color
                positionCell.nameLabel.text = position.name
            }
        }
        
        return cell
    }
    
    func onClickClose(sender: UIButton) {
        positionArray.removeObjectAtIndex(sender.tag)
        employeesTable.reloadData()
    }
    // MARK: - ShiftLocationViewControllerDelegate
    func locationDidSelect(locationObj: NSLocation) {
        locationData = locationObj
        self.employeesTable.reloadData()
    }
    
    // MARK: - SelectPositionViewControllerDelegate
    func positionArrayDidSelect(positionArray: NSArray) {
        self.positionArray.addObjectsFromArray(positionArray as [AnyObject])
        self.employeesTable.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowShiftLocationVC {
            let destVC = segue.destinationViewController as! ShiftLocationViewController
            destVC.delegate = self
        } else if segue.identifier == kShowSelectPositionVC {
            let destVC = segue.destinationViewController as! SelectPositionViewController
            destVC.delegate = self
            destVC.isFromEmployee = true
        }
    }

}
