//
//  ShiftPositionViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftPositionTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
}

protocol ShiftPositionViewControllerDelegate {
    func positionDidSelect(positionObj: NSPosition)
}

class ShiftPositionViewController: UIViewController {

    private let cellIdentifier = "PositionCell"
    
    @IBOutlet weak var shiftPositionTable: UITableView!
    
    var positionArray = NSMutableArray()
    var delegate: ShiftPositionViewControllerDelegate? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftPosition")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.show()
        NSAPIClient.sharedInstance.getPositionList { (nsData, error) -> Void in
            print(nsData)
            SVProgressHUD.dismiss()
            
            if (error == nil) {
                self.positionArray.removeAllObjects()
                for positionDict in nsData!["data"] as! NSArray {
                    let positionObj = NSPosition.initWithDictionary(positionDict as! NSDictionary)
                    if (positionObj != nil) {
                        self.positionArray.addObject(positionObj!)
                    }
                }
                self.shiftPositionTable.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (self.delegate?.positionDidSelect(self.positionArray[indexPath.row] as! NSPosition)) != nil {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return positionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let positionObj = positionArray[indexPath.row] as! NSPosition
        (cell as! ShiftPositionTableCell).titleLabel.text = positionObj.name
        (cell as! ShiftPositionTableCell).statusButton.backgroundColor = positionObj.color
        
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
