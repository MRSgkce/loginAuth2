import UIKit
import FirebaseFirestore
import FirebaseAuth
import UIKit
import FirebaseFirestore
import FirebaseAuth

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Drone {
    var imeId: String
    var macId: String
    var ownerId: String
    var typeId: String
    var photoURL: String?
    
    init(imeId: String, macId: String, ownerId: String, typeId: String, photoURL: String? = nil) {
        self.imeId = imeId
        self.macId = macId
        self.ownerId = ownerId
        self.typeId = typeId
        self.photoURL = photoURL
    }
}
class DroneType {
    var typeId: String
    var photoURL: String
    var name: String
    
    init(typeId: String, photoURL: String, name: String) {
        self.typeId = typeId
        self.photoURL = photoURL
        self.name = name
    }
}


/*


class Drone: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var drones: [Drones] = [] // Drone'ları tutacak model dizisi
    var db: Firestore!

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Firebase Firestore başlatma
        db = Firestore.firestore()

        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomDroneCell.self, forCellReuseIdentifier: "CustomDroneCell") // Özel hücre kaydı
        view.addSubview(tableView)

        // TableView düzenlemeleri için Auto Layout
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Kullanıcı bilgilerini al ve drone'ları çek
        fetchUserDrones()
    }

    func fetchUserDrones() {
        // Kullanıcının giriş yapıp yapmadığını kontrol et
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // 'drones' koleksiyonunda 'ownerId' ile kullanıcının drone'larını sorgulama
        db.collection("drones").whereField("ownerId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                // Hata varsa mesajı yazdır
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            // Snapshot null ise hata mesajı ver
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }

            // Drone'ları alıp işle
            self.drones.removeAll()
            for document in snapshot.documents {
                let data = document.data()
                if let imeId = data["imeId"] as? String,
                   let macId = data["macId"] as? String,
                   let name = data["name"] as? String,
                   let ownerId = data["ownerId"] as? String,
                   let typeId = data["typeId"] as? String {
                    
                    // Drones modelini oluşturup listeye ekle
                    let drone = Drones(imeId: imeId, macId: macId, name:name, ownerId: ownerId, typeId: typeId)
                    self.drones.append(drone)
                } else {
                    // Eğer bazı veriler eksikse, mesaj yazdır
                    print("Data missing in document: \(document.documentID)")
                }
            }

            // Veriler yüklendikten sonra UI'ı güncelle
            DispatchQueue.main.async {
                self.tableView.reloadData() // UI güncellemesini ana thread'de yap
            }
        }
    }

    // MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drones.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // CustomDroneCell'i kullanıyoruz
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDroneCell", for: indexPath) as? CustomDroneCell else {
            return UITableViewCell()
        }

        let drone = drones[indexPath.row]
        cell.droneImageView.image = UIImage(named: "drone_image") // Drone resmi
        cell.titleLabel.text = "Dji \(drone.typeId)" // Başlık
        cell.detailLabel.text = "\(drone.imeId) \(drone.macId)" // Alt detay
        cell.infoLabel.text = "\(drone.name)" // Sağdaki bilgi etiketi
        return cell
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Hücre yüksekliği
    }
}

// Drones Model
class Drones {
    var imeId: String
    var macId: String
    var name: String
    var ownerId: String
    var typeId: String

    init(imeId: String, macId: String,name: String, ownerId: String, typeId: String) {
        self.imeId = imeId
        self.macId = macId
        self.name = name
        self.ownerId = ownerId
        self.typeId = typeId
    }
}

// Custom Drone Cell
class CustomDroneCell: UITableViewCell {

    // Görseller ve etiketler
    let droneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()

    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()

    // Başlatıcı (initializer)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black // Hücrenin arka plan rengi

        // Alt öğeleri ekle
        contentView.addSubview(droneImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(infoLabel)

        // Auto Layout Kurulumu
        NSLayoutConstraint.activate([
            // Drone resmi
            droneImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            droneImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            droneImageView.widthAnchor.constraint(equalToConstant: 50),
            droneImageView.heightAnchor.constraint(equalToConstant: 50),

            // Başlık
            titleLabel.leadingAnchor.constraint(equalTo: droneImageView.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoLabel.leadingAnchor, constant: -10),

            // Detay
            detailLabel.leadingAnchor.constraint(equalTo: droneImageView.trailingAnchor, constant: 15),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoLabel.leadingAnchor, constant: -10),

            // Bilgi etiketi
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

*/

/*

class Drone: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var drones: [Drones] = [] // Drone'ları tutacak model dizisi
    var db: Firestore!

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Firebase Firestore başlatma
        db = Firestore.firestore()

        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // TableView düzenlemeleri için Auto Layout
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Kullanıcı bilgilerini al ve drone'ları çek
        fetchUserDrones()
    }

    func fetchUserDrones() {
        // Kullanıcının giriş yapıp yapmadığını kontrol et
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // 'drones' koleksiyonunda 'ownerId' ile kullanıcının drone'larını sorgulama
        db.collection("drones").whereField("ownerId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                // Hata varsa mesajı yazdır
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            // Snapshot null ise hata mesajı ver
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }

            // Drone'ları alıp işle
            self.drones.removeAll()
            for document in snapshot.documents {
                let data = document.data()
                if let imeId = data["imeId"] as? String,
                   let macId = data["macId"] as? String,
                   let ownerId = data["ownerId"] as? String,
                   let typeId = data["typeId"] as? String {
                    
                    // Drones modelini oluşturup listeye ekle
                    let drone = Drones(imeId: imeId, macId: macId, ownerId: ownerId, typeId: typeId)
                    self.drones.append(drone)
                } else {
                    // Eğer bazı veriler eksikse, mesaj yazdır
                    print("Data missing in document: \(document.documentID)")
                }
            }

            // Veriler yüklendikten sonra UI'ı güncelle
            DispatchQueue.main.async {
                self.tableView.reloadData() // UI güncellemesini ana thread'de yap
            }
        }
    }

    // MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drones.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Hücreyi özel bir stil ile oluşturuyoruz
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DroneCell")
        
        let drone = drones[indexPath.row]
        
        // Ana başlık: Owner ID
        cell.textLabel?.text = "Owner ID: \(drone.ownerId)"
        // Alt başlık: Detaylar (IMEI, MAC, Type)
        cell.detailTextLabel?.text = "image: \(drone.imeId), MAC: \(drone.macId), Type: \(drone.typeId)"
        
        // Hücrede bir ok göstermek için
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

class Drones {
    var imeId: String
    var macId: String
    var ownerId: String
    var typeId: String

    init(imeId: String, macId: String, ownerId: String, typeId: String) {
        self.imeId = imeId
        self.macId = macId
        self.ownerId = ownerId
        self.typeId = typeId
    }
}
*/


