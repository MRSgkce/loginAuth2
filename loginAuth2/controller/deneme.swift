//
//  deneme.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 16.11.2024.
import UIKit
import Firebase
import FirebaseAuth
import UIKit
import FirebaseFirestore
import FirebaseAuth
import UIKit
import FirebaseFirestore
import FirebaseAuth
import UIKit
import Firebase

import UIKit
import FirebaseFirestore
import FirebaseAuth
/*
class deneme: UIViewController {
    
    var drones: [Drone] = [] // Drone model dizisi
    var db: Firestore!
    
    var imageView: UIImageView! // Fotoğrafı göstermek için ImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firestore instance oluştur
        db = Firestore.firestore()
        
        // `imageView`'ı programatik olarak oluştur
        setupImageView()
        
        // Kullanıcı drone'larını çek
        fetchUserDrones()
    }
    
    // ImageView yapılandırma
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Auto Layout kısıtlamalarını ayarla
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    // Kullanıcının drone'larını çek
    private func fetchUserDrones() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış")
            return
        }
        
        // `drones` koleksiyonundan `ownerId` alanı eşleşen belgeleri al
        db.collection("drones").whereField("ownerId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Belgeler alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Herhangi bir belge bulunamadı")
                return
            }
            
            self.drones.removeAll() // Daha önceki verileri sıfırla
            for document in documents {
                let data = document.data()
                
                if let imeId = data["imeId"] as? String,
                   let macId = data["macId"] as? String,
                   let ownerId = data["ownerId"] as? String,
                   let typeId = data["typeId"] as? String {
                    
                    // Drone nesnesini oluştur
                    let drone = Drone(imeId: imeId, macId: macId, ownerId: ownerId, typeId: typeId)
                    self.drones.append(drone)
                    
                    // Drone tipine ait bilgileri getir
                    self.fetchDroneTypeDetails(for: typeId, drone: drone)
                }
            }
        }
    }
    
    // Drone tipi bilgilerini çek
    private func fetchDroneTypeDetails(for typeId: String, drone: Drone) {
        db.collection("droneTypes").document(typeId).getDocument { document, error in
            if let error = error {
                print("Drone tipi bilgileri alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Drone tipi bulunamadı: \(typeId)")
                return
            }
            
            let data = document.data()
            if let photoURL = data?["photoURL"] as? String {
                // Drone nesnesine fotoğraf URL'sini ekle
                drone.photoURL = photoURL
                
                // Fotoğrafı yükle ve UI'ı güncelle
                DispatchQueue.main.async {
                    self.loadImage(from: photoURL)
                }
            }
        }
    }
    
    // Fotoğrafı yükle ve ImageView'da göster
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fotoğraf yüklenirken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}

// Drone Modeli
class Drone {
    var imeId: String
    var macId: String
    var ownerId: String
    var typeId: String
    var photoURL: String?
    
    init(imeId: String, macId: String, ownerId: String, typeId: String) {
        self.imeId = imeId
        self.macId = macId
        self.ownerId = ownerId
        self.typeId = typeId
    }
}


*/



/*

class deneme: UIViewController {

    var drones: [Drones] = [] // Drones model dizisi
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore() // Firestore instance

        // Kullanıcı drone'larını çek
        fetchUserDrones()
    }

    // Kullanıcının drone'larını çekme
    func fetchUserDrones() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // Drones koleksiyonundaki drone'ları çek
        db.collection("drones").whereField("ownerId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }

            self.drones.removeAll() // Drones dizisini sıfırlıyoruz
            for document in snapshot.documents {
                let data = document.data()
                
                if let imeId = data["imeId"] as? String,
                   let macId = data["macId"] as? String,
                   let ownerId = data["ownerId"] as? String,
                   let typeId = data["typeId"] as? String {

                    // Drone nesnesini oluştur
                    let drone = Drones(imeId: imeId, macId: macId, ownerId: ownerId, typeId: typeId)
                    self.drones.append(drone)
                    
                    // Drone tipiyle ilgili bilgileri çek
                    self.fetchDroneTypeDetails(for: typeId, for: drone)
                }
            }

            DispatchQueue.main.async {
                // TableView'ı güncelle
                // self.tableView.reloadData()
            }
        }
    }

    // DroneTypes koleksiyonundan drone tipi bilgilerini çekme
    func fetchDroneTypeDetails(for typeId: String, for drone: Drones) {
        db.collection("droneTypes").document(typeId).getDocument { document, error in
            if let error = error {
                print("Error getting drone type details: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists else {
                print("No matching drone type found for \(typeId)")
                return
            }

            let data = document.data()
            if let name = data?["name"] as? String,
               let photoURL = data?["photoURL"] as? String,
               let description = data?["description"] as? String {

                // Drone nesnesine tipiyle ilgili bilgileri ekliyoruz
                drone.name = name
                drone.photoURL = photoURL
                drone.description = description

                DispatchQueue.main.async {
                    // Fotoğrafı yükleyip UI'ı güncelle
                    // self.tableView.reloadData()
                }
            }
        }
    }
}

// Drones Modeli
class Drones {
    var imeId: String
    var macId: String
    var ownerId: String
    var typeId: String
    var name: String?
    var photoURL: String?
    var description: String?

    init(imeId: String, macId: String, ownerId: String, typeId: String) {
        self.imeId = imeId
        self.macId = macId
        self.ownerId = ownerId
        self.typeId = typeId
    }
}
*/
