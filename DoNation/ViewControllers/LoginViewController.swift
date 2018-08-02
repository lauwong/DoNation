//
//  LoginViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 11/14/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    //MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        setupViewResizerOnKeyboardShown()
        
        // 1
        //        Auth.auth().addStateDidChangeListener() { auth, user in
        //            // 2
        //            if user != nil {
        //                // 3
        //
        //            }
        //        }
        
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        Auth.auth().signIn(withEmail: textFieldLoginEmail.text!,
                           password: textFieldLoginPassword.text!)  {
                            (user, error) in
                            if let user = Auth.auth().currentUser {
                                if !user.isEmailVerified{
                                    guard let emailAddress = self.textFieldLoginEmail.text else{
                                        return
                                    }
                                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(emailAddress)?", preferredStyle: .alert)
                                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                                        (_) in
                                        user.sendEmailVerification(completion: nil)
                                    }
                                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                                    
                                    alertVC.addAction(alertActionCancel)
                                    alertVC.addAction(alertActionOkay)
                                    self.present(alertVC, animated: true, completion: nil)
                                } else {
                                    print ("Email verified. Signing in...")
                                    self.performSegue(withIdentifier: self.loginToList, sender: nil)
                                }
                            } else {
                                let alertController = UIAlertController(title: "Error", message: "Authentication failed. Check your connection and credentials.", preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
        }
    }
    
    //    @IBAction func signUpDidTouch(_ sender: AnyObject) {
    //        let alert = UIAlertController(title: "Register",
    //                                      message: "Register",
    //                                      preferredStyle: .alert)
    //
    //        let saveAction = UIAlertAction(title: "Save",
    //                                       style: .default) { action in
    //
    //                                        // 1
    //                                        let emailField = alert.textFields![0]
    //                                        let passwordField = alert.textFields![1]
    //
    //                                        // 2
    //                                        Auth.auth().createUser(withEmail: emailField.text!,
    //                                                                   password: passwordField.text!) { user, error in
    //                                                                    if error == nil {
    //                                                                        if let user = Auth.auth().currentUser{
    //                                                                        // 3
    //                                                                        user.sendEmailVerification(completion: nil)
    //                                                                        }
    //                                                                    }
    //                                        }
    //
    //        }
    //
    //        let cancelAction = UIAlertAction(title: "Cancel",
    //                                         style: .default)
    //
    //        alert.addTextField { textEmail in
    //            textEmail.placeholder = "Enter your email"
    //        }
    //
    //        alert.addTextField { textPassword in
    //            textPassword.isSecureTextEntry = true
    //            textPassword.placeholder = "Enter your password"
    //        }
    //
    //        alert.addAction(saveAction)
    //        alert.addAction(cancelAction)
    //
    //        present(alert, animated: true, completion: nil)
    //    }
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        
        if self.textFieldLoginEmail.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.textFieldLoginEmail.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.textFieldLoginEmail.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

extension UIViewController {
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
    
}
