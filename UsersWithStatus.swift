//
//  UsersWithStatus.swift
//  DoNation
//
//  Created by Lauren Wong on 10/30/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit
import Firebase

class UsersWithStatus {
    //MARK: Properties
    var email: String
    /*var contactPhone: String
    var webAddress: String */
    var isApproved: Bool
    let usersRef: DatabaseReference?
    let key: String
    
    init?(email: String, /*contactPhone: String, webAddress: String,*/ isApproved: Bool, key: String = "") {
        if email.isEmpty /*|| contactPhone.isEmpty || webAddress.isEmpty*/ {
            return nil
        }
        self.key = key
        self.email = email
        /*self.contactPhone = contactPhone
        self.webAddress = webAddress */
        self.isApproved = isApproved
        self.usersRef = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        /*contactPhone = snapshotValue["contactPhone"] as! String
        webAddress = snapshotValue["webAddress"] as! String*/
        isApproved = snapshotValue["isApproved"] as! Bool
        usersRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            /*"contactPhone": contactPhone,
            "webAddress": webAddress,*/
            "isApproved": isApproved,
        ]
    }
    
    
}
