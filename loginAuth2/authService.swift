//
//  authService.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 2.11.2024.


import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class authService {
    public static let shared = authService()
    private init() {}
    
    // Kullanıcı kaydı
    public func registerUser(with userRequest: register, completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            let db = Firestore.firestore()
            db.collection("users").document(resultUser.uid).setData([
                "username": username,
                "email": email
            ]) { error in
                completion(error == nil, error)
            }
        }
    }

    // Kullanıcı girişi
    public func signIn(with userRequest: login, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { _, error in
            completion(error)
        }
    }
    
    // Kullanıcı çıkışı
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    // Şifremi unuttum işlemi
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }

    // Kullanıcı verilerini çekme
    public func fetchUser(completion: @escaping (useri?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userUID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let snapshotData = snapshot?.data(),
                  let username = snapshotData["username"] as? String,
                  let email = snapshotData["email"] as? String else {
                completion(nil, NSError(domain: "UserError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı verisi bulunamadı"]))
                return
            }
            let profileImageUrl = snapshotData["profileImageUrl"] as? String
            let user = useri(username: username, email: email, userUID: userUID, profileImageUrl: profileImageUrl)
            completion(user, nil)
        }
    }

    // Profil güncelleme: kullanıcı adı ve profil resmi
    public func updateUserProfile(username: String, profileImageData: Data?, completion: @escaping (Bool, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        var updatedData: [String: Any] = ["username": username]
        
        if let profileImageData = profileImageData {
            let storageRef = Storage.storage().reference().child("profile_images").child("\(userUID).jpg")
            
            storageRef.putData(profileImageData, metadata: nil) { _, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    if let profileImageUrl = url {
                        updatedData["profileImageUrl"] = profileImageUrl.absoluteString
                    }
                    
                    db.collection("users").document(userUID).updateData(updatedData) { error in
                        completion(error == nil, error)
                    }
                }
            }
        } else {
            db.collection("users").document(userUID).updateData(updatedData) { error in
                completion(error == nil, error)
            }
        }
    }

    // Hesap silme işlemi
    public func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Giriş yapılmış kullanıcı yok"]))
            return
        }
        
        // İlk olarak Firestore'daki kullanıcı verisini sil
        Firestore.firestore().collection("users").document(user.uid).delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            // Sonrasında kullanıcıyı Firebase Authentication'dan sil
            user.delete { error in
                completion(error)
            }
        }
    }
}























/*
class authService {
    public static let shared = authService()
    private init() {}
    
    // Kullanıcı kaydı
    public func registerUser(with userRequest: register, completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            let db = Firestore.firestore()
            db.collection("users").document(resultUser.uid).setData(["username": username, "email": email]) { error in
                completion(error == nil, error)
            }
        }
    }

    // Kullanıcı girişi
    public func signIn(with userRequest: login, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { _, error in
            completion(error)
        }
    }
    
    // Kullanıcı çıkışı
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    // Şifremi unuttum işlemi
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }

    // Kullanıcı verilerini çekme
    public func fetchUser(completion: @escaping (useri?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userUID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let snapshot = snapshot, let snapshotData = snapshot.data(),
                  let username = snapshotData["username"] as? String,
                  let email = snapshotData["email"] as? String else {
                completion(nil, NSError(domain: "UserError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
                return
            }
            let user = useri(username: username, email: email, userUID: userUID)
            completion(user, nil)
        }
    }

    // Profil güncelleme: kullanıcı adı ve profil resmi
    public func updateUserProfile(username: String, profileImageData: Data?, completion: @escaping (Bool, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        var updatedData: [String: Any] = ["username": username]
        
        if let profileImageData = profileImageData {
            let storageRef = Storage.storage().reference().child("profile_images").child("\(userUID).jpg")
            
            storageRef.putData(profileImageData, metadata: nil) { _, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    if let profileImageUrl = url {
                        updatedData["profileImageUrl"] = profileImageUrl.absoluteString
                    }
                    
                    db.collection("users").document(userUID).updateData(updatedData) { error in
                        completion(error == nil, error)
                    }
                }
            }
        } else {
            db.collection("users").document(userUID).updateData(updatedData) { error in
                completion(error == nil, error)
            }
        }
    }

    // Hesap silme işlemi
    public func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in"]))
            return
        }
        
        // İlk olarak Firestore'daki kullanıcı verisini sil
        Firestore.firestore().collection("users").document(user.uid).delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            // Sonrasında kullanıcıyı Firebase Authentication'dan sil
            user.delete { error in
                completion(error)
            }
        }
    }
}


        */
        
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
        
            
        
            
   

