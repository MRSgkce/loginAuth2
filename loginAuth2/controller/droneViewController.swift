//
//  droneViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 18.11.2024.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage



    class DroneViewController: UITableViewController {
        
        var drones: [Drone] = []
        var droneTypes: [String: DroneType] = [:] // DroneType nesnelerini ID'ye göre eşleştirme
        
        private let db = Firestore.firestore()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Hücre kaydı
            tableView.register(DroneTableViewCell.self, forCellReuseIdentifier: "DroneCell")
            
            // Veriyi yükle
            fetchUserDrones()
        }
        
        // Kullanıcı drone'larını yükleme
        private func fetchUserDrones() {
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Kullanıcı oturum açmamış")
                return
            }
            
            db.collection("drones").whereField("ownerId", isEqualTo: userId).getDocuments { snapshot, error in
                if let error = error {
                    print("Drone'lar alınırken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("Drone bulunamadı.")
                    return
                }
                
                self.drones = documents.compactMap { document in
                    let data = document.data()
                    guard let imeId = data["imeId"] as? String,
                          let macId = data["macId"] as? String,
                          let ownerId = data["ownerId"] as? String,
                          let typeId = data["typeId"] as? String else {
                              return nil
                          }
                    return Drone(imeId: imeId, macId: macId, ownerId: ownerId, typeId: typeId)
                }
                
                // DroneType'ları yükle
                self.fetchDroneTypes()
            }
        }
        
        // DroneType bilgilerini yükleme
        private func fetchDroneTypes() {
            let typeIds = Array(Set(drones.map { $0.typeId }))
            
            for typeId in typeIds {
                db.collection("droneTypes").document(typeId).getDocument { document, error in
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
                    self.droneTypes[typeId] = droneType
                    
                    // Tabloyu güncelle
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        // Tablo hücre sayısı
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return drones.count
        }
        
        // Hücre oluşturma ve veri bağlama
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DroneCell", for: indexPath) as! DroneTableViewCell
            let drone = drones[indexPath.row]
            
            if let droneType = droneTypes[drone.typeId] {
                cell.configure(with: droneType)
            }
            
            return cell
        }
    }
