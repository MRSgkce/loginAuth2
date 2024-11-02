//
//  authService.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 2.11.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestore
class authService {
    public static let shared = authService()
    private init() {}
    
    public func registerUser(with userRequest: register,completion: @escaping (Bool, Error?) -> Void) {
        let username=userRequest.username
        let email=userRequest.email
        let password=userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error=error {
                completion(false, error)
                return
            }
            guard let resultuser = result?.user else {
                completion(false, nil)
                return
            }
            let db =  Firestore.firestore()
            db.collection("users").document(resultuser.uid).setData(["username":username,"email":email]) { error in
                if let error=error {
                    completion(false, error)
                    return
                    
                }
                completion(true, nil)
            }
            
        }
    }

    public func signIn(with userRequest: login,completion: @escaping(Error?)->Void ){
        Auth.auth().signIn(withEmail: userRequest.email,password: userRequest.password){
            result, error in
            if let error=error {
                completion(error)
                return
            }else{
                completion(nil)
            }
            
        }
    }
    
    
    public func signOut(completion: @escaping (Error?) -> Void){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch{
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String,completion: @escaping (Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email){
            error in
            if let error=error {
                completion(error)
                return
            }else{
                completion(nil)
            }
        }
    }
    
    public func fetchUser(completion: @escaping (useri?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userUID).getDocument(source: .default) { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot,
               let snapshotData = snapshot.data(),
               let username = snapshotData["username"] as? String,
               let email = snapshotData["email"] as? String {
                let user = useri(username: username, email: email, userUID: userUID)
                completion(user, nil)
            } else {
                completion(nil, NSError(domain: "UserError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
            }
        }
        
    }
        
        
//
//        db.collection("users").document(userUID).getDocument{
//            userUID.snapshot, error in
//            if let error = error {
//                completion(nil,error)
//                return
//            }
//            if let snapshot = snapshot,
//               let snapshotData = snapshot.data(),
//               let username = snapshotData["username"] as? String,
//             let email = snapshotData["email"] as? String  {
//                let user = User(username : username, email: email, uid: userUID)
//                completion(user,nil)
//                  
        }
            
        
            
   

