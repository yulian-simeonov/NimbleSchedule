//
//  CreatePositionViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 12/18/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class CreatePositionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var positionTitleTextField: UITextField!
    @IBOutlet weak var colorPanelView: UIView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var selectColorLabel: UILabel!
    @IBOutlet weak var selectColorDescLabel: UILabel!
    
    var colorArray = []
    var colorSelIndex = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("CreatePosition")
        self.positionTitleTextField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("PositionTitle")
        self.selectColorDescLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("SelectColor")
        self.selectColorLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("SelectColor")
        self.doneBarButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colorArray = ["db6f93", "b7ffb7", "4cdbb7", "db4c4c", "934cff", "4ca54c", "db6f93", "93db4c", "db6f93", "b76f93", "db4cff", "b74c6f", "dbdbdb", "934c6f", "ffb7db", "cc3366", "6f6f6f", "b3844c", "b793ff", "b7dbff", "4c4cdb", "dbb793", "ff936f", "ffffb7", "93ffff", "936fdb", "ffdb4c" ]
        
        self.buildColorPanel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        positionTitleTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    // MARK: - UI Utility Functions
    func buildColorPanel() {
        
        let padding = CGFloat(7)
        let numberOfCols = 9
        let wid = CGFloat((SCRN_WIDTH - 30 - padding * CGFloat(numberOfCols - 1)) / CGFloat(numberOfCols))
        
        for row in 0...2 {
            for col in 0...8 {
                let xPos = CGFloat((wid + padding) * CGFloat(col))
                let yPos = CGFloat(CGFloat(row) * (wid + padding))
                let button = UIButton.init(frame: CGRectMake(xPos, yPos, wid, wid))
                
                button.tag = row * numberOfCols + col + 1
                button.backgroundColor = UIColor.init(rgba: "#" + (colorArray[row * numberOfCols + col] as! String))
                button.addTarget(self, action: Selector("onClickColor:"), forControlEvents: .TouchUpInside)
                
                if button.tag == 1 {
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor.init(rgba: "#4ed37a").CGColor
                }
                
                colorPanelView.addSubview(button)
            }
        }
    }
    
    // MARK: - Button Action
    func onClickColor(sender: UIButton) {
        
        for i in 1...27 {
            let button = colorPanelView.viewWithTag(i) as! UIButton
            button.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.init(rgba: "#4ed37a").CGColor
        
        colorSelIndex = sender.tag - 1
    }

    @IBAction func onClickDone(sender: AnyObject) {
        
        if !Utilities.isValidData(positionTitleTextField.text) {
            positionTitleTextField.layer.borderColor = UIColor.redColor().CGColor
            positionTitleTextField.layer.borderWidth = 1.0
            return
        }
        positionTitleTextField.layer.borderWidth = 0
        NSAPIClient.sharedInstance.createPositionWithName(positionTitleTextField.text!, positionColor: colorArray[colorSelIndex] as! String) { (nsData, error) -> Void in
            if error != nil {
                print(error?.description)
                Utilities.showMsgWithTitle("Position exists already", message: "This position already exists in the system. Try using a different title", delegate: self)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
            print(nsData)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
 