//
//  validator.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 2.11.2024.
//

import Foundation

class validator {
    
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        
    }
    
    static func isvalidUsername (for username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameregex = "\\w{4,24}"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameregex)
        return usernamePred.evaluate(with: username)
    }
    
    
    static func isValidPassword(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordregex = "\\w{4,24}"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordregex)
        return passwordPred.evaluate(with: password)
    }
}
