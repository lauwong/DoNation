//
//  User.swift
//  DoNation
//
//  Created by Lauren Wong on 11/20/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import Foundation
import Firebase

struct UserClass {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String, displayName: String) {
        self.uid = uid
        self.email = email
    }
    
}

