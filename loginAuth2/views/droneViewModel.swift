//
//  droneViewModel.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 18.11.2024.
//


import FirebaseFirestore
import FirebaseAuth
import UIKit
import Foundation
import FirebaseCore
import FirebaseStorage
import Foundation
import FirebaseFirestore
import FirebaseAuth

class DroneViewModel {
    private let db = Firestore.firestore()
    private(set) var drones: [Drone] = []
    private(set) var droneTypes: [String: DroneType] = [:]
    
    var reloadTableView: (() -> Void)? // TableView'ı güncellemek için Closure
    
    // Kullanıcı drone'larını yükleme
    func fetchUserDrones() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış")
            return
        }
        
        db.collection("drones").whereField("ownerId", isEqualTo: userId).getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Drone'lar alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Drone bulunamadı.")
                return
            }
            
            self?.drones = documents.compactMap { document in
                let data = document.data()
                guard let imeId = data["imeId"] as? String,
                      let macId = data["macId"] as? String,
                      let ownerId = data["ownerId"] as? String,
                      let typeId = data["typeId"] as? String else {
                          return nil
                      }
                return Drone(imeId: imeId, macId: macId, ownerId: ownerId, typeId: typeId)
            }
            
            self?.fetchDroneTypes()
        }
    }
    
    // DroneType bilgilerini yükleme
    private func fetchDroneTypes() {
        let typeIds = Array(Set(drones.map { $0.typeId }))
        
        for typeId in typeIds {
            db.collection("droneTypes").document(typeId).getDocument { [weak self] document, error in
                if let error = error {
                    print("Drone tipi alınırken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document, document.exists,
                      let data = document.data(),
                      let photoURL = data["photoURL"] as? String,
                      let name = data["name"] as? String else {
                          return
                      }
                
                let droneType = DroneType(typeId: typeId, photoURL: photoURL, name: name)
                self?.droneTypes[typeId] = droneType
                
                // Closure'ı çağırarak tabloyu güncelle
                self?.reloadTableView?()
            }
        }
    }
}
