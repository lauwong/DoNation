//
//  RequestExpandedViewController.swift
//  DoNation
//
//  Created by Lauren Wong on 11/20/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase

class RequestExpandedViewController: UIViewController {
    
    var ref: DatabaseReference!
    var selectedRequest: Requests?
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var addressCityLabel: UILabel!
//    @IBOutlet weak var stateZipLabel: UILabel!
    @IBOutlet weak var webAddressView: UITextView!
    //    @IBOutlet weak var openCloseLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var needsLabelView: UITextView!
    @IBOutlet weak var haveDonatedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "requests")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = selectedRequest?.title
        organizationLabel.text = selectedRequest?.organization
        addressCityLabel.text = selectedRequest?.address
        webAddressView.text = selectedRequest?.webAddress
//        stateZipLabel.text = stateZipText
        //        let openCloseText = "Open from " + (selectedRequest?.openFrom)! + " to " + (selectedRequest?.closingAt)!
        //        openCloseLabel.text = openCloseText
        contactInfoLabel.text = (selectedRequest?.contactEmail)! + " ⋅ " + (selectedRequest?.contactPhone)!
        needsLabelView.text = selectedRequest?.description
    }
    
//    @IBAction func haveDonatedButton(_ sender: UIButton) {
//        if let numDonations = selectedRequest?.donations, let dbKey = self.title?.lowercased(), let intDonations = Int(numDonations), let requestTitle = selectedRequest?.title {
//            
//            let defaults = UserDefaults.standard
//            var token = defaults.dictionary(forKey: "hasDonatedDict")
//
//            if let hasDonated = token?[requestTitle] as? Bool {
//                if hasDonated {
//                    let newNumDonations = intDonations - 1
//                    self.ref.child(dbKey).child("donations").setValue(String(newNumDonations))
//                    haveDonatedButton.backgroundColor = UIColor(red: 83/255, green: 212/255, blue: 180/255, alpha: 1.0)
//                    haveDonatedButton.setTitle("I Donated!", for: .normal)
//                    token?[requestTitle] = false
//                    defaults.set(token, forKey: "hasDonatedDict")
//                } else {
//                    let newNumDonations = intDonations + 1
//                    self.ref.child(dbKey).child("donations").setValue(String(newNumDonations))
//                    haveDonatedButton.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
//                    haveDonatedButton.setTitle("Whoops! I Haven't Donated.", for: .normal)
//                    token?[requestTitle] = true
//                    defaults.set(token, forKey: "hasDonatedDict")
//                }
//            }
//        }
//    }
    
}
