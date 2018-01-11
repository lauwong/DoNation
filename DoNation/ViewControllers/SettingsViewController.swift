//
//  SettingsViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 11/29/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var changePwTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    @IBOutlet weak var oldPwTextField: UITextField!
    @IBOutlet weak var changeEmailTextField: UITextField!
    let usersRef = Database.database().reference(withPath: "users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        setupViewResizerOnKeyboardShown()
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        let alertDelete = UIAlertController(title: "Delete Account",
                                      message: "Are you sure you want to delete your account?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Delete",
                                       style: .default) { action in
                                        
                                        self.usersRef.child("users").queryOrdered(byChild: "email").queryEqual(toValue: Auth.auth().currentUser?.email).observeSingleEvent(of: .value, with: { snapshot in
                                            for item in snapshot.children {
                                                // 4
                                                let userItem = UsersWithStatus(snapshot: item as! DataSnapshot)
                                                if(userItem.email == Auth.auth().currentUser?.email){
                                                    userItem.usersRef?.removeValue()
                                                }
                                            }
                                        })
                                        
                                        if let user = Auth.auth().currentUser {
                                            user.delete { error in
                                                if let error = error {
                                                    // An error happened.
                                                    print(error)
                                                } else {
                                                    // Account deleted.
                                                }
                                            }
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        
        alertDelete.addAction(saveAction)
        alertDelete.addAction(cancelAction)
        
        self.present(alertDelete, animated: true, completion: nil)
    }
    
    @IBAction func saveChangesPressed(_ sender: UIButton) {
        
        if oldPwTextField.text != nil && changePwTextField.text != nil && confirmPwTextField.text != nil {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: oldPwTextField.text!)
            
            user?.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    // handle error - incorrect password entered is a possibility
                    let alertWrongPW = UIAlertController(title: "Incorrect Password",
                                                       message: "The password you have submitted is incorrect.",
                                                       preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Dismiss",
                                                     style: .default)
                    alertWrongPW.addAction(cancelAction)
                    self.present(alertWrongPW, animated: true, completion: nil)
                    return
                } else {
                    if self.changePwTextField.text == self.confirmPwTextField.text {
                        user?.updatePassword(to: self.changePwTextField.text!, completion: nil)
                        
                        let alertChangeSuccessful = UIAlertController(title: "Success!",
                                                             message: "You have successfully changed your password.",
                                                             preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Dismiss",
                                                         style: .default)
                        alertChangeSuccessful.addAction(cancelAction)
                        self.present(alertChangeSuccessful, animated: true, completion: nil)
                        
                        self.oldPwTextField.text = ""
                        self.changePwTextField.text = ""
                        self.confirmPwTextField.text = ""
                        
                        self.dismissKeyboard()
                        
                    }
                }
            })
        }
    }
    
    @IBAction func changeEmailPressed(_ sender: UIButton) {
        if let newEmail = changeEmailTextField.text {
            let user = Auth.auth().currentUser
            user?.updateEmail(to: newEmail, completion: nil)
            user?.sendEmailVerification(completion: nil)
            let alertEmailChange = UIAlertController(title: "Success!",
                                                          message: "You have successfully changed your email. A verification will be sent to your new address.",
                                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss",
                                             style: .default)
            alertEmailChange.addAction(cancelAction)
            self.present(alertEmailChange, animated: true, completion: nil)
            self.changeEmailTextField.text = ""
            self.dismissKeyboard()
        } else{
            
        }
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
