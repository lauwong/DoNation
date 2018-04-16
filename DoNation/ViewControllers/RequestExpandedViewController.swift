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
    
    let ref = Database.database().reference(withPath: "requests")
    var selectedRequest: Requests?
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var addressCityLabel: UILabel!
    @IBOutlet weak var stateZipLabel: UILabel!
//    @IBOutlet weak var openCloseLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var needsLabelView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = selectedRequest?.title
        organizationLabel.text = selectedRequest?.organization
        addressCityLabel.text = selectedRequest?.address
        let stateZipText = (selectedRequest?.state)! + ", " + (selectedRequest?.zip)!
        stateZipLabel.text = stateZipText
//        let openCloseText = "Open from " + (selectedRequest?.openFrom)! + " to " + (selectedRequest?.closingAt)!
//        openCloseLabel.text = openCloseText
        contactInfoLabel.text = (selectedRequest?.contactEmail)! + " ⋅ " + (selectedRequest?.contactPhone)!
        needsLabelView.text = selectedRequest?.description
    }
    
    
}
