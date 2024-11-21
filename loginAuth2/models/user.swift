//
//  user.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 2.11.2024.
//

import Foundation
/*
class useri{
    let username: String
    let email: String
    let userUID: String
    
    
    init(username: String, email: String, userUID: String) {
            self.username = username
            self.email = email
            self.userUID = userUID
        }
}*/

class useri {
    let username: String
    let email: String
    let userUID: String
    var profileImageUrl: String?  // Profil resmi URL'si

    init(username: String, email: String, userUID: String, profileImageUrl: String? = nil) {
        self.username = username
        self.email = email
        self.userUID = userUID
        self.profileImageUrl = profileImageUrl
    }
}

