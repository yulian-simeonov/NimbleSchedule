//
//  ShiftFilterViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/18/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftFilterViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var positionView: UIView!
    
    @IBOutlet weak var locationViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var positionViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeiConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterbyLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var resetFiltersButton: NSRoundButton!
    @IBOutlet weak var applyButton: NSRoundButton!
    
    var locationArray: NSMutableArray = []
    var positionArray: NSMutableArray = []
    
    let kMargin: CGFloat = 10
    var kButtonWid: CGFloat = 80
    let kButtonHei: CGFloat = 25
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftFilter")
        self.filterbyLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("FILTER_BY")
        self.locationButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Location"), forState: .Normal)
        self.positionButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Position"), forState: .Normal)
        self.resetFiltersButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("RESET_FILTERS"), forState: .Normal)
        self.applyButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("APPLY"), forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        // Initialize Array
        locationArray = ["Location1", "Location2", "Location3", "Location4", "Location5"]
        positionArray = ["Position1", "Position2", "Position3", "Position4", "Position5"]

        
        self.updateContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickLocation(sender: AnyObject) {
        
    }
    
    @IBAction func onClickPosition(sender: AnyObject) {
        
    }
    // MARK: - UI Function
    func buttonWithTitle(title: NSString) -> UIView {
        
        let buttonView = UIView.init(frame: CGRectMake(0, 0, kButtonWid, kButtonHei))
        buttonView.layer.cornerRadius = 5
        buttonView.backgroundColor = MAIN_COLOR

        // Title Label
        let titleLabel = UILabel.init(frame: CGRectMake(10, 0, kButtonWid - 30, kButtonHei))
        titleLabel.text = title as String
        titleLabel.font = Utilities.fontWithSize(15.0)
        titleLabel.textColor = UIColor.whiteColor()
        
        buttonView.addSubview(titleLabel)

        
        let frame = buttonView.frame
        let cancelButton = UIButton.init(frame: CGRectMake(frame.size.width - 20, 0, 20, frame.size.height))
        cancelButton.userInteractionEnabled = false
        cancelButton.setTitle("X", forState: UIControlState.Normal)
        
        buttonView.addSubview(cancelButton)
        
        
        return buttonView
    }
    
    func updateContent() {
        // Clear View
        locationView.subviews.forEach{$0.removeFromSuperview()}
        positionView.subviews.forEach{$0.removeFromSuperview()}
    
        
        kButtonWid = (SCRN_WIDTH - 30 - kMargin*4) / 3
        
        locationViewHeiConstraint.constant = ceil(CGFloat(locationArray.count) / 3.0) * (kButtonHei + 5) + 10
        positionViewHeiConstraint.constant = ceil(CGFloat(positionArray.count) / 3.0) * (kButtonHei + 5) + 10
        
        // Build Location Buttons
        if (locationArray.count > 0) {
            for i in 0...locationArray.count-1 {
                let button = self.buttonWithTitle(locationArray[i] as! NSString)
                
                let yPos = CGFloat(10 + Int(i / 3) * Int(kButtonHei + 5))
                let xPos = CGFloat(10 + (i % 3) * Int(kButtonWid + kMargin))
                var frame = button.frame;
                frame.origin.x = xPos
                frame.origin.y = yPos
                button.frame = frame
                
                self.locationView.addSubview(button)
                
                button.tag = i
                
                let tapGes = UITapGestureRecognizer(target: self, action: Selector("handleLocationTap:"))
                tapGes.delegate = self
                button.addGestureRecognizer(tapGes)
            }
        } else {
            locationViewHeiConstraint.constant = 5
        }
        
        // Build Position Buttons
        if (positionArray.count > 0) {
            for i in 0...positionArray.count-1 {
                let button = self.buttonWithTitle(positionArray[i] as! NSString)
                
                let yPos = CGFloat(10 + Int(i / 3) * Int(kButtonHei + 5))
                let xPos = CGFloat(10 + (i % 3) * Int(kButtonWid + kMargin))
                var frame = button.frame;
                frame.origin.x = xPos
                frame.origin.y = yPos
                button.frame = frame
                
                button.tag = i;
                
                self.positionView.addSubview(button)

                let tapGes = UITapGestureRecognizer(target: self, action: Selector("handlePositionTap:"))
                tapGes.delegate = self
                button.addGestureRecognizer(tapGes)
            }
        } else {
            positionViewHeiConstraint.constant = 5
        }
        
        self.containerViewHeiConstraint.constant = 120                                                                                                                                                                                                                                                                                          + locationViewHeiConstraint.constant + positionViewHeiConstraint.constant
    }
    
    func handleLocationTap(recognizer: UITapGestureRecognizer) {
        
        let translation = recognizer.locationInView(recognizer.view)
        let index = recognizer.view?.tag
        if (translation.x > (recognizer.view?.frame.size.width)! - 30) {
            print("Tap inside")
            locationArray.removeObjectAtIndex(index!)
            
            self.updateContent()
        } else {
            print("Tap outside")
        }
    }
    
    func handlePositionTap(recognizer: UITapGestureRecognizer) {
        
        let translation = recognizer.locationInView(recognizer.view)
        let index = recognizer.view?.tag
        if (translation.x > (recognizer.view?.frame.size.width)! - 30) {
            print("Tap inside")
            positionArray.removeObjectAtIndex(index!)
            
            self.updateContent()
        } else {
            print("Tap outside")
        }
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
