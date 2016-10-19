//
//  LoginViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/21/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameView : UIView!
    @IBOutlet weak var passwordView : UIView!
    @IBOutlet weak var signInButton : NSLoadingButton!
    @IBOutlet weak var signInHelpButton : UIButton!
    @IBOutlet weak var orLabel : UILabel!
    @IBOutlet weak var signInFacebookButton : UIButton!
    @IBOutlet weak var signInWithGoogle : UIButton!
    @IBOutlet weak var noAccessButton : UIButton!
    @IBOutlet weak var constraintHeight : NSLayoutConstraint!
    @IBOutlet weak var firstSection : UIView!
    @IBOutlet weak var secondSection: UIView!
    @IBOutlet weak var thirdSection : UIView!
    @IBOutlet weak var fingerprintButton : UIButton!
    @IBOutlet weak var fingerprintSecondButton : UIButton!
    
    enum LAError : Int{
        case AuthenticationFailed
        case UserCancel
        case UserFallback
        case SystemCancel
        case PasscodeNotSet
        case TouchIDNotAvailable
        case TouchIDNotEnrolled
    }
    
    var  authenticationContext = LAContext()
    var defaultUsername : String!
    var defaultPassword : String!
    var error:NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //hide help view
        self.signInHelpButton.alpha = 0
        self.constraintHeight.constant = 0
        //self.view.setNeedsLayout()
        
        //localization
        self.emailTextField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Dashboard")
        self.passwordTextField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Password")
        self.signInButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("SIGNIN"), forState: UIControlState.Normal)
        self.signInHelpButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("NeedHelpSigningIn"), forState: UIControlState.Normal)
        self.orLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("OR")
       // self.signInFacebookButton.setTitle(NSLocalizedString("Sign in using Facebook", comment: "Sign in using Facebook"), forState: UIControlState.Normal)
        //self.signInWithGoogle.setTitle(NSLocalizedString("Sign in using Google+", comment: "Sign in using Google+"), forState: UIControlState.Normal)
        self.noAccessButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("DontHaveAccount"), forState: UIControlState.Normal)
        self.fingerprintSecondButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("SignInWithFingerprint"), forState: UIControlState.Normal)
        
        self.addGrayBorderToView(self.usernameView)
        self.addGrayBorderToView(self.passwordView)
        
        self.fingerprintButton.layer.cornerRadius = self.fingerprintButton.layer.frame.size.height/2
        
        //keyboard dismissing
        
        let tap = UITapGestureRecognizer.init(target: self, action:"hideKeyboard")
        self.view.addGestureRecognizer(tap)
              // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)        
       self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.defaultUsername = Utilities.getDefaultUsername()
        self.defaultPassword = Utilities.getDefaultPassword()
        
        if Utilities.isStringValid(self.defaultUsername) == false || self.canEvauluate() == false{
            self.fingerprintSecondButton.hidden = true
            self.fingerprintButton.hidden = true
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fadeSectionIn(self.firstSection)
        self.fadeSectionIn(self.secondSection)
        self.fadeSectionIn(self.thirdSection)
        self.fadeSectionIn(self.noAccessButton)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK authentication
    
    //check if phone can use touch id
    func canEvauluate () -> Bool {
        return self.authenticationContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    
    @IBAction func authenticateUser(sender : AnyObject) {
       let reasonString = NSLocalizedString("Try signing in with your previous sign in info", comment: "Try signing in with your previous sign in info")
        self.authenticationContext = LAContext()
        
       
        if authenticationContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [authenticationContext .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    SVProgressHUD.show()
                    self.emailTextField.text = self.defaultUsername
                    self.passwordTextField.text = self.defaultPassword
                    self.signInButton.loading = true
                    self.signIn(self.defaultUsername, password: self.defaultPassword)
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    print(evalPolicyError?.localizedDescription)
                       print (evalPolicyError!.code)
                    switch evalPolicyError!.code {
                     
                    case -3:
                        print("User selected to enter custom password")
                        
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        print("Authentication was cancelled by the user")
                        
                    default:
                        print("Authentication failed")
                       
                    }
                }
                
            })]
        }
        
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                print("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                print("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                print("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            print(error?.localizedDescription)
          
        }
    }
    
    func hideKeyboard(){
    self.view.endEditing(true)
    }
    
    func setupContents() {
        
    }
    //MARK textFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.emailTextField){
        self.passwordTextField.becomeFirstResponder()
        }
        else{
        self.onClickSignIn(self.signInButton)
        }
        return false
    }
    
    // MARK: - UIButton Action
    @IBAction func onClickBack(sender: AnyObject) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onClickSignIn(sender: NSLoadingButton) {
        
        var status:Bool = true
        if  Utilities.isValidData(self.emailTextField.text) == false {
            status = false
        }
        
        if Utilities.isValidData(self.passwordTextField.text) == false {
            status = false
        }
        
        if (!status) {
              Utilities.showMsg("Please fill out all fields", delegate: self)
            return
        }
//        else {
//            if !Utilities.isValidEmail(self.emailTextField.text!) {
//                self.emailTextField.drawRedOutLine()
//                return;
//            }
//        }
        
        sender.loading = true
        sender.setActivityIndicatorAlignment(NSLoadingButtonAlignmentCenter)
        
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            SharedDataManager.sharedInstance.rootVC .didLoggedIn()
//        })

        self.view.endEditing(true)
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.signIn(self.emailTextField.text!, password: self.passwordTextField.text!)
           }
    
    func signIn(username : String, password : String){
        NSAPIClient.authInstance.signIn(username, password: password) { (nsData, error) -> Void in
            self.signInButton.loading = false
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if ((error) != nil) {
                print(error?.description)
                //   Utilities.showMsg("Login Failed", delegate: self)
                self.addRedBorderToView(self.usernameView)
                self.addRedBorderToView(self.passwordView)
                self.showSignupHelpView()
            } else {
                 Utilities.setFingerprintLoginInfo(self.emailTextField.text!, password: self.passwordTextField.text!)
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    SharedDataManager.sharedInstance.rootVC .didLoggedIn()
                })
            }
        }

    }
    
    func addGrayBorderToView (view : UIView){
    view.layer.borderColor = UIColor.grayColor().CGColor
    view.layer.borderWidth = 0.5
    }
    
    func addRedBorderToView (view : UIView){
        view.layer.borderColor = UIColor.redColor().CGColor
        view.layer.borderWidth = 1
        self.shakeView(view)
    }
    
    //pragma animations
    func shakeView(view : UIView){
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPointMake(view.center.x - 5, view.center.y)
        let from_value:NSValue = NSValue(CGPoint: from_point)
        
        let to_point:CGPoint = CGPointMake(view.center.x + 5, view.center.y)
        let to_value:NSValue = NSValue(CGPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        view.layer.addAnimation(shake, forKey: "position")
    }
    
    func showSignupHelpView(){
    UIView.animateWithDuration(0.3) { () -> Void in
        self.signInHelpButton.alpha = 1
        self.constraintHeight.constant = 40
        self.view.setNeedsLayout()
        }
    }
    
    func fadeSectionIn(view : UIView){
    UIView.animateWithDuration(0.3) { () -> Void in
        view.alpha = 1
        }
    }
    
    @IBAction func openSignupLink (sender : AnyObject){
    self.openLink("https://www.google.rs/")
    }
    
    @IBAction func openHelpLink (sender : AnyObject){
    self.openLink("https://www.google.rs/")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func openLink (link : String){
    UIApplication.sharedApplication().openURL(NSURL(string: link)!)
    }

}
