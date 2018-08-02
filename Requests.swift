//
//  Requests.swift
//  DoNation
//
//  Created by Lauren Wong on 10/30/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase

class Requests {
    //MARK: Properties
    var title: String
    var organization: String
    var description: String
    var address: String
    var webAddress: String
//    var state: String
//    var zip: String
//    var openFrom: String
//    var closingAt: String
    var requestedByUser: String
    var contactEmail: String
    var contactPhone: String
    var donations: String
    let ref: DatabaseReference?
    let key: String
    
    init?(title: String, organization: String, description: String, address: String, webAddress: String, /*state: String, zip: String, openFrom: String, closingAt: String,*/ requestedByUser: String, contactEmail: String, contactPhone: String, donations: String, key: String = "") {
        if (title.isEmpty || organization.isEmpty || description.isEmpty || address.isEmpty || /*state.isEmpty || zip.isEmpty || openFrom.isEmpty || closingAt.isEmpty ||*/ contactEmail.isEmpty || contactPhone.isEmpty) {
            return nil
        }
        self.key = key
        self.title = title
        self.organization = organization
        self.description = description
        self.address = address
        self.webAddress = webAddress
//        self.state = state
//        self.zip = zip
//        self.openFrom = openFrom
//        self.closingAt = closingAt
        self.requestedByUser = requestedByUser
        self.contactEmail = contactEmail
        self.contactPhone = contactPhone
        self.donations = donations
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        organization = snapshotValue["organization"] as! String
        description = snapshotValue["description"] as! String
        address = snapshotValue["address"] as! String
        webAddress = snapshotValue["webAddress"] as! String
//        state = snapshotValue["state"] as! String
//        zip = snapshotValue["zip"] as! String
//        openFrom = snapshotValue["openFrom"] as! String
//        closingAt = snapshotValue["closingAt"] as! String
        requestedByUser = snapshotValue["requestedByUser"] as! String
        contactEmail = snapshotValue["contactEmail"] as! String
        contactPhone = snapshotValue["contactPhone"] as! String
        donations = snapshotValue["donations"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "organization": organization,
            "description": description,
            "address": address,
            "webAddress": webAddress,
//            "state": state,
//            "zip": zip,
//            "openFrom": openFrom,
//            "closingAt": closingAt,
            "requestedByUser": requestedByUser,
            "contactEmail": contactEmail,
            "contactPhone": contactPhone,
            "donations": donations
        ]
    }
    
    
}
