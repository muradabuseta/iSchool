//
//  LoginViewController.swift
//  iSchool
//
//  Created by Björn Orri Sæmundsson on 28/08/14.
//  Copyright (c) 2014 OrangeJam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidAppear(animated: Bool) {
        registerForKeyboardNotification()
    }
    
    @IBAction func didPressLoginButton(sender: UIButton) {
        let username = usernameField.text
        let password = passwordField.text
        let credentialManager = CredentialManager.sharedInstance
        let networkClient = NetworkClient(username: username, password: password);
        NSLog("Button pressed")
        activityIndicator.startAnimating()
        networkClient.fetchPage(Page.Assignments,
            successHandler: authenticationSucceeded,
            errorHandler: authenticationFailed
        )
    }
    
    func registerForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardDidAppear:",
            name: UIKeyboardDidShowNotification,
            object: nil
        )
    }
    
    func keyboardDidAppear(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.height

        if CGRectContainsPoint(aRect, loginButton.frame.origin) {
            scrollView.scrollRectToVisible(loginButton.frame, animated: true)
        }
    }
    
    func authenticationSucceeded(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void {
        activityIndicator.stopAnimating()
        NSLog("Success")
        let credentialManager = CredentialManager.sharedInstance
        credentialManager.storeCredentials(usernameField.text, passwordField.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticationFailed(operation: AFHTTPRequestOperation!, error: NSError!) -> Void {
        activityIndicator.stopAnimating()
        let statusCode = operation.response.statusCode
        clearFields()
        switch(statusCode){
        // TODO: Add more cases for better error messages
        case (401):
            NSLog("Unauthenticated")
            messageLabel.text = "Authentication Failed."
        default:
            NSLog("Myschool Error")
            messageLabel.text = "Network Error."
        }
        
    }
    
    func clearFields() -> Void {
        usernameField.text = ""
        passwordField.text = ""
    }
    
    override func viewDidLoad() {
        NSLog("login screen")
        super.viewDidLoad()
    }
    
}