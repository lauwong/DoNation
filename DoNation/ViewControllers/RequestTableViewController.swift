//
//  RequestTableViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 10/30/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase

class RequestTableViewController: UITableViewController {
    //MARK: Properties
    
    var requestDisplays = [Requests]()
    var user: User!
    let ref = Database.database().reference(withPath: "requests")
    let usersRef = Database.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 1
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [Requests] = []
            
            // 3
            for item in snapshot.children {
                // 4
                let requestItem = Requests(snapshot: item as! DataSnapshot)
                if(requestItem.approved){
                    newItems.append(requestItem)
                }
            }
            
            // 5
            self.requestDisplays = newItems
            self.tableView.reloadData()
        })
        
        usersRef.child("users").queryOrdered(byChild: "email").queryEqual(toValue: (Auth.auth().currentUser?.email)!).observe(.value, with: { snapshot in
            print(snapshot)
            if let allUsers = snapshot.value as? [String:AnyObject] {
                for (_,users) in allUsers {
                    let userIsDonor = users["isDonor"]
                    if let stringBoolDonor = userIsDonor, let boolDonorTwo = stringBoolDonor {
                        if String(describing: boolDonorTwo) == "1" {
                            self.navigationItem.rightBarButtonItem = nil
                        }
                        print (String(describing: boolDonorTwo))
                    }
                }
            } else {
                print("all users is nil")
                print(String(describing: (Auth.auth().currentUser?.email)!))
            }
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
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        try! Auth.auth().signOut()
    }
    
    @IBAction func addRequestPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "homeToAddRequestNav", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            // Get selected request
            let request = requestDisplays[indexPath.row]
            // Get our expanded view controller
            let requestExpandedVC = segue.destination as! RequestExpandedViewController
            // Pass selected request to our expanded view controller
            requestExpandedVC.selectedRequest = request
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
