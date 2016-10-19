//
//  SelectPositionViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/18/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class PositionTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    
    // This button is not for this class. It is for Edit Location and Position Class
    @IBOutlet weak var closeButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.checkButton != nil {
            if (selected) {
                self.checkButton.selected = selected
            } else {
                self.checkButton.selected = selected
            }
        }
    }
}

protocol SelectPositionViewControllerDelegate {
    func positionArrayDidSelect(positionArray: NSArray)
}

class SelectPositionViewController: UIViewController {
    private let cellIdentifier = "PositionCell"
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var positionTable: UITableView!
    @IBOutlet weak var tableViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var createPositionButton: UIButton!
    
    var positionArray = NSMutableArray()
    var delegate: SelectPositionViewControllerDelegate? = nil
    var isFromEmployee: Bool = false
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftPosition")
        self.doneBarButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
        self.createPositionButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("CREATE_A_POSITION"), forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewHeiConstraint.constant = isFromEmployee ? 52 : 0
        tableViewTopConstraint.constant = isFromEmployee ? -44 : 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.localizeContent()

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
                self.positionTable.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickDone(sender: AnyObject) {
        
        let selPositionArray = NSMutableArray()
        for selIndexPath in positionTable.indexPathsForSelectedRows! {
            selPositionArray.addObject(positionArray[selIndexPath.row])
        }
        if (selPositionArray.count > 0) {
            if self.delegate?.positionArrayDidSelect(selPositionArray) != nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }

    @IBAction func onClickCreate(sender: AnyObject) {
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.positionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let positionObj = positionArray[indexPath.row] as! NSPosition
        (cell as! PositionTableCell).nameLabel.text = positionObj.name
        (cell as! PositionTableCell).statusButton.backgroundColor = positionObj.color
        
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
