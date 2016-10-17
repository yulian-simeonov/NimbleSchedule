//
//  ShiftNotesViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol ShiftNotesViewControllerDelegate {
    func shiftNotesDidSelect(shiftNotes: String)
}

class ShiftNotesViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shiftNotesLabel: UILabel!
    
    var shiftNotes: String = ""
    
    var delegate: ShiftNotesViewControllerDelegate? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftNotes")
        self.cancelButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
        self.cancelButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Cancel")
        self.shiftNotesLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("SHIFT_NOTES")
        (self.notesTextView as! NSPlaceholderTextView).placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Enter_your_shift_notes_here")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        notesTextView.becomeFirstResponder()
        notesTextView.text = shiftNotes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Function
    func updateContent() {
        
    }
    
    @IBAction func onClickCancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onClickDone(sender: AnyObject) {
        
        if notesTextView.text.isEmpty {
            Utilities.showMsg("Please enter text first!", delegate: self)
            return
        }
        if self.delegate?.shiftNotesDidSelect(notesTextView.text) != nil {
            self.navigationController?.popViewControllerAnimated(true)
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
