//
//  RequestTableViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 10/30/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase
import os.log

class RequestTableViewController: UITableViewController {
    //MARK: Properties
    
    var requestDisplays = [Requests]()
    var user: User!
    var ref: DatabaseReference!
    var usersRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "requests")
        usersRef = Database.database().reference(withPath: "donors")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                if let user = Auth.auth().currentUser {
                    if user.isEmailVerified {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Request",
                                                                                 style: UIBarButtonItemStyle.plain ,
                                                                                 target: self, action: #selector(self.addRequestForm))
                        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                                                style: UIBarButtonItemStyle.plain ,
                                                                                target: self, action: #selector(self.signOutPressed))
                    } else {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tripleBarIcon"),
                                                                                 style: UIBarButtonItemStyle.plain ,
                                                                                 target: self, action: #selector(self.orgOptionsPressed))
                        self.navigationItem.leftBarButtonItem = nil
                    }
                }
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tripleBarIcon"),
                                                                         style: UIBarButtonItemStyle.plain ,
                                                                         target: self, action: #selector(self.orgOptionsPressed))
                self.navigationItem.leftBarButtonItem = nil
            }
        }
        
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [Requests] = []
            
            // 3
//            print(snapshot)
            
            for item in snapshot.children {
                let requestItem = Requests(snapshot: item as! DataSnapshot)
//                print(requestItem)
                
                self.usersRef.child("users").queryOrdered(byChild: "email").queryEqual(toValue: requestItem.requestedByUser).observe(.value, with: { snapshot in
                    //                    print(snapshot)
                    if let allUsers = snapshot.value as? [String:AnyObject] {
                        for (_,users) in allUsers {
                            let userIsApproved = users["isApproved"]
                            //                            print(userIsApproved)
                            if let stringBoolApproved = userIsApproved, let boolApprovedTwo = stringBoolApproved as? Int {
                                //                                print(boolApprovedTwo)
                                if (boolApprovedTwo == 1) {
                                    newItems.append(requestItem)
                                }
                            }
                        }
                    } else {
                        //                        os_log("all users is nil")
                        //                        print(String(describing: (Auth.auth().currentUser?.email)!))
                    }
                    
                    self.requestDisplays = newItems
                    self.tableView.reloadData()
                    
                    if(self.requestDisplays.count < 1) {
                        let noRequests = UIAlertController(title: "No Requests",
                                                           message: "There are currently no requests. Come back later to check!",
                                                           preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK",
                                                         style: .default)
                        noRequests.addAction(cancelAction)
                        self.present(noRequests, animated: true, completion: nil)
                    }
                    
                })
            }
            
            // 5
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requestDisplays.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RequestTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RequestTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RequestTableViewCell.")
        }
        let request = requestDisplays[indexPath.row]
        
        cell.titleLabel.text = request.title
        cell.organizationLabel.text = request.organization
        cell.descriptionTextView.text = request.description
        
        return cell
    }
    
    @objc func signOutPressed() {
        //dismiss(animated: true, completion: nil)
        try! Auth.auth().signOut()
    }
    
    @objc func orgOptionsPressed() {
        let orgOptions = UIAlertController(title: "Organization Options",
                                           message: "Use an organization account to post requests!",
                                           preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        let logInAction = UIAlertAction(title: "Log In",
                                        style: .default) {
                                            (_) in
                                            let alert = UIAlertController(title: "Log In",
                                                                          message: "",
                                                                          preferredStyle: .alert)
                                            
                                            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                                                
                                                let emailField = alert.textFields![0]
                                                let passwordField = alert.textFields![1]
                                                
                                                Auth.auth().signIn(withEmail: emailField.text!,
                                                                   password: passwordField.text!){
                                                                    (user, error) in
                                                                    if let user = Auth.auth().currentUser {
                                                                        if user.isEmailVerified {
                                                                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Request", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addRequestForm))
                                                                            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                                                                                                    style: UIBarButtonItemStyle.plain ,
                                                                                                                                    target: self, action: #selector(self.signOutPressed))
                                                                        } else {
                                                                            guard let emailAddress = emailField.text else{
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
                                                                        }
                                                                    } else {
                                                                        let alertController = UIAlertController(title: "Error", message: "Authentication failed. Check your connection and credentials.", preferredStyle: .alert)
                                                                        
                                                                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                                        alertController.addAction(defaultAction)
                                                                        
                                                                        self.present(alertController, animated: true, completion: nil)
                                                                    }
                                                }
                                            }
                                            
                                            let cancelAction = UIAlertAction(title: "Cancel",
                                                                             style: .cancel)
                                            
                                            alert.addTextField { textEmail in
                                                textEmail.placeholder = "Email"
                                            }
                                            
                                            alert.addTextField { textPassword in
                                                textPassword.isSecureTextEntry = true
                                                textPassword.placeholder = "Password"
                                            }
                                            
                                            alert.addAction(saveAction)
                                            alert.addAction(cancelAction)
                                            
                                            self.present(alert, animated: true, completion: nil)
                                            
        }
        let signUpAction = UIAlertAction(title: "Sign Up",
                                         style: .default) {
                                            (_) in
                                            self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
                                            //                                            let alert = UIAlertController(title: "Sign Up",
                                            //                                                                          message: "",
                                            //                                                                          preferredStyle: .alert)
                                            //
                                            //                                            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                                            //
                                            //                                                let emailField = alert.textFields![0]
                                            //                                                let passwordField = alert.textFields![1]
                                            //
                                            //                                                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                                            //                                                    if error == nil {
                                            //                                                        Auth.auth().signIn(withEmail: emailField.text!,
                                            //                                                                           password: passwordField.text!)
                                            //                                                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Request",
                                            //                                                                                         style: UIBarButtonItemStyle.plain ,
                                            //                                                                                         target: self, action: #selector(self.addRequestForm))
                                            //                                                        let userItem = UsersWithStatus(email: emailField.text!, isApproved: false)
                                            //                                                        if userItem == nil {
                                            ////                                                           emptyFieldAlert()
                                            //                                                        } else{
                                            //                                                            let userItemRef = self.usersRef.child("users").childByAutoId()
                                            //                                                            userItemRef.setValue(userItem?.toAnyObject())
                                            //                                                        }
                                            //                                                    }
                                            //                                                }
                                            //                                            }
                                            //
                                            //                                            let cancelAction = UIAlertAction(title: "Cancel",
                                            //                                                                             style: .cancel)
                                            //
                                            //                                            alert.addTextField { textEmail in
                                            //                                                textEmail.placeholder = "Email"
                                            //                                            }
                                            //
                                            //                                            alert.addTextField { textPassword in
                                            //                                                textPassword.isSecureTextEntry = true
                                            //                                                textPassword.placeholder = "Password"
                                            //                                            }
                                            //
                                            //                                            alert.addAction(saveAction)
                                            //                                            alert.addAction(cancelAction)
                                            //
                                            //                                            self.present(alert, animated: true, completion: nil)
        }
        
        orgOptions.addAction(cancelAction)
        orgOptions.addAction(signUpAction)
        orgOptions.addAction(logInAction)
        
        self.present(orgOptions, animated: true, completion: nil)
    }
    
    @objc func addRequestForm() {
        performSegue(withIdentifier: "presentAddRequest", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToExpanded"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // Get selected request
                let request = requestDisplays[indexPath.row]
                // Get our expanded view controller
                let requestExpandedVC = segue.destination as! RequestExpandedViewController
                // Pass selected request to our expanded view controller
                requestExpandedVC.selectedRequest = request
            }
        }
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        var isByUser = false
        if let currentUser = Auth.auth().currentUser {
            if let orgEmail = currentUser.email {
//                print(orgEmail)
//                print(self.requestDisplays[indexPath.row].requestedByUser)
                if orgEmail == self.requestDisplays[indexPath.row].requestedByUser {
                    isByUser = true
                } else {
                    isByUser = false
                }
            }
        }
        print(isByUser)
        return isByUser
     }
    
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            let requestItem = requestDisplays[indexPath.row]
            requestItem.ref?.removeValue()
         }
     }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
