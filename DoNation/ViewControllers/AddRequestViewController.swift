//
//  ViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 10/16/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//
/*
 Watched tutorial by Yp.py https://www.youtube.com/watch?v=_ADJxJ7pjRk
 */

import UIKit
import os.log
import Firebase
import CoreLocation

class AddRequestViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
//    var info = [[String]]()
//
//    var titles = [String]()
//    var orgs = [String]()
//    var addresses = [String]()
//    var states = [String]()
//    var zipCodes = [String]()
//    var openDates = [String]()
//    var closeDates = [String]()
//    var IDs = [String]()
//    var needs = [String]()
    
    @IBOutlet weak var requestScrollView: UIScrollView!
    
//    @IBOutlet weak var openDateTextField: UITextField!
    
//    @IBOutlet weak var closeDateTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var orgTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var needsTextView: UITextView!
    
    var request: Requests?
    var user: UserClass!
    
    let datePicker = UIDatePicker()
    let listToUsers = "ListToUsers"
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "requests")
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddRequestViewController.dismissKeyboard))
        setupViewResizerOnKeyboardShown()
//        createDatePicker()
        
        requestScrollView.delegate = self
//        openDateTextField.delegate = self
//        closeDateTextField.delegate = self
        titleTextField.delegate = self
        orgTextField.delegate = self
        addressTextField.delegate = self
        stateTextField.delegate = self
        zipTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        needsTextView.delegate = self
        
        needsTextView.layer.cornerRadius = 5
        needsTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        needsTextView.layer.borderWidth = 0.4
        
        requestScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.size.height+100)
        
//        info.append(titles)
//        info.append(orgs)
//        info.append(addresses)
//        info.append(states)
//        info.append(zipCodes)
//        info.append(openDates)
//        info.append(closeDates)
//        info.append(IDs)
//        info.append(needs)
        view.addGestureRecognizer(tap)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = UserClass(authData: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func createDatePicker(){
//        //format
//        datePicker.datePickerMode = .date
//
//        //toolbar
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        //flexible space
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//
//        //bar button item
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//        toolbar.setItems([flexSpace, doneButton], animated: false)
//
//        openDateTextField.inputAccessoryView = toolbar
//        closeDateTextField.inputAccessoryView = toolbar
//
//        //assigning datepicker to textfield
//        openDateTextField.inputView = datePicker
//        closeDateTextField.inputView = datePicker
//    }
    
    @objc func donePressed(){
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
//        if(openDateTextField .isFirstResponder){
//            openDateTextField.text = dateFormatter.string(from: datePicker.date)
//        } else if (closeDateTextField .isFirstResponder) {
//            closeDateTextField.text = dateFormatter.string(from: datePicker.date)
//        }
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func requestDonePressed(_ sender: UIBarButtonItem) {
//        info[0].append(titleTextField.text!)
//        info[1].append(orgTextField.text!)
//        info[2].append(addressTextField.text!)
//        info[3].append(openDateTextField.text!)
//        info[4].append(closeDateTextField.text!)
//        info[5].append(openDateTextField.text!)
//        info[6].append(closeDateTextField.text!)
//        info[7].append(IdTextField.text!)
//        info[8].append(needsTextView.text!)
//        print(info)
        
        let titleText = self.titleTextField.text!
        let organizationText = self.orgTextField.text!
        let descriptionText = self.needsTextView.text!
        let addressText = self.addressTextField.text!
        let stateText = self.stateTextField.text!
        let zipText = self.zipTextField.text!
        let emailAddress = self.emailTextField.text!
        let phoneNumber = self.phoneTextField.text!
        
        if let currentUser = Auth.auth().currentUser, let currentEmail = currentUser.email {
            let requestItem = Requests(title: titleText, organization: organizationText, description: descriptionText, address: addressText, state: stateText, zip: zipText, requestedByUser: currentEmail, contactEmail: emailAddress, contactPhone: phoneNumber)
            
            if requestItem == nil {
                let alertEmpty = UIAlertController(title: "Empty Field",
                                                   message: "You have an empty field. Please fill every field to submit.",
                                                   preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Dismiss",
                                                 style: .default)
                alertEmpty.addAction(cancelAction)
                present(alertEmpty, animated: true, completion: nil)
            } else{
                //3
                let requestItemRef = self.ref.child(titleText.lowercased())
                
                // 4
                requestItemRef.setValue(requestItem?.toAnyObject())
                
                dismiss(animated: true, completion: nil)
            }
        }
        
        // 2
    }
    
    @IBAction func requestCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}


