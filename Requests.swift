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
    var state: String
    var zip: String
    var openFrom: String
    var closingAt: String
    var requestedByUser: String
    var approved: Bool
    let ref: DatabaseReference?
    let key: String
    
    init?(title: String, organization: String, description: String, address: String, state: String, zip: String, openFrom: String, closingAt: String, requestedByUser: String, approved: Bool, key: String = "") {
        if title.isEmpty || organization.isEmpty || description.isEmpty || address.isEmpty ||
            state.isEmpty || zip.isEmpty || openFrom.isEmpty || closingAt.isEmpty {
            return nil
        }
        self.key = key
        self.title = title
        self.organization = organization
        self.description = description
        self.address = address
        self.state = state
        self.zip = zip
        self.openFrom = openFrom
        self.closingAt = closingAt
        self.requestedByUser = requestedByUser
        self.approved = approved
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        organization = snapshotValue["organization"] as! String
        description = snapshotValue["description"] as! String
        address = snapshotValue["address"] as! String
        state = snapshotValue["state"] as! String
        zip = snapshotValue["zip"] as! String
        openFrom = snapshotValue["openFrom"] as! String
        closingAt = snapshotValue["closingAt"] as! String
        requestedByUser = snapshotValue["requestedByUser"] as! String
        approved = snapshotValue["approved"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "organization": organization,
            "description": description,
            "address": address,
            "state": state,
            "zip": zip,
            "openFrom": openFrom,
            "closingAt": closingAt,
            "requestedByUser": requestedByUser,
            "approved": approved
        ]
    }
    
    
}
