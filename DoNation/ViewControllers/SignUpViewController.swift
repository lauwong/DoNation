//
//  SignUpViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 12/1/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPwTextField: UITextField!
    @IBOutlet weak var signUpConfirmPwTextField: UITextField!
    var usersRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersRef = Database.database().reference(withPath: "donors")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        setupViewResizerOnKeyboardShown()
        
        signUpEmailTextField.delegate = self
        signUpPwTextField.delegate = self
        signUpConfirmPwTextField.delegate = self
        
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signUpDonorPressed(_ sender: UIButton) {
        signUp(isApproved: true)
    }
    
    @IBAction func signUpOrgPressed(_ sender: UIButton) {
        signUp(isApproved: false)
    }
    
    @IBAction func signUpCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func signUp(isApproved: Bool) {
        if let signUpEmail = signUpEmailTextField.text, let signUpPass = signUpPwTextField.text {
                if signUpPass == signUpConfirmPwTextField.text {
                    Auth.auth().createUser(withEmail: signUpEmail, password: signUpPass) { user, error in
                        //                        print(Auth.auth().currentUser)
                        if error == nil {
                            if let user = Auth.auth().currentUser {
                                user.sendEmailVerification(completion: nil)
                            }
                        }
                    }
                    
                    let userItem = UsersWithStatus(email: signUpEmail, isApproved: isApproved)
                    if userItem == nil {
                        emptyFieldAlert()
                    } else {
                        let userItemRef = self.usersRef.child("users").childByAutoId()
                        userItemRef.setValue(userItem?.toAnyObject())
                        dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                    let signUpConfirmNotEqualAlert = UIAlertController(title: "Passwords Don't Match",
                                                                       message: "The password you entered to confirm does not match the password you chose.",
                                                                       preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Dismiss",
                                                     style: .default)
                    
                    signUpConfirmNotEqualAlert.addAction(cancelAction)
                    present(signUpConfirmNotEqualAlert, animated: true, completion: nil)
                }
        } else {
            emptyFieldAlert()
        }
    }
    
    func emptyFieldAlert() {
        let alertEmptyField = UIAlertController(title: "Empty Field",
                                                message: "You have an empty field. Please fill every field to submit.",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss",
                                         style: .default)
        alertEmptyField.addAction(cancelAction)
        present(alertEmptyField, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
