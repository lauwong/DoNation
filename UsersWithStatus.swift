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
    var isApproved: Bool
    let usersRef: DatabaseReference?
    let key: String
    
    init?(email: String, isApproved: Bool, key: String = "") {
        if email.isEmpty {
            return nil
        }
        self.key = key
        self.email = email
        self.isApproved = isApproved
        self.usersRef = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        isApproved = snapshotValue["isApproved"] as! Bool
        usersRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "isApproved": isApproved,
        ]
    }
    
    
}
