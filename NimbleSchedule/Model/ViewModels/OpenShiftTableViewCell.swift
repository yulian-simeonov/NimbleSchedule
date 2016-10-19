//
//  OpenShiftTableViewCell.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/2/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class OpenShiftTableViewCell: UITableViewCell {

    var swipeLeftGesture: UISwipeGestureRecognizer!
    var swipeRightGesture: UISwipeGestureRecognizer!
    
    @IBOutlet weak var outlineView: UIView!
    @IBOutlet weak var statusViewWidConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickupButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        outlineView.layer.borderWidth = 0.7
        outlineView.layer.borderColor = MAIN_COLOR.CGColor

        self.showPickupButton(false, animated: false)
        
        
        // Create Gesture for swipe action
        swipeLeftGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("swipeLeftGestureHandler:"))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        swipeRightGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("swipeRightGestureHandler:"))
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        
        self.addGestureRecognizer(swipeRightGesture)
        self.addGestureRecognizer(swipeLeftGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func swipeLeftGestureHandler(sender: AnyObject) {
        self .showPickupButton(true, animated: true)
    }
    
    @IBAction func swipeRightGestureHandler(sender: AnyObject) {
        self .showPickupButton(false, animated: true)
    }
    
    // MARK: - UI Utility Functions
    func showPickupButton(isShow: Bool, animated: Bool) {
        if (isShow) {
            self.statusViewWidConstraint.constant = 60
        } else {
            self.statusViewWidConstraint.constant = 6
        }
        
        if (animated) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self .layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.pickupButton.hidden = !isShow
            })
        } else {
            self.pickupButton.hidden = !isShow
        }
    }
    
}
