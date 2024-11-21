import UIKit
import FirebaseAuth
import UIKit
import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

// Özel CollectionView hücresi
class CustomCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class homeview2Controller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    let imageNames = ["foto4", "foto2", "foto1", "foto3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogoutButton()
        
       // view.backgroundColor = .white
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
           backgroundImage.image = UIImage(named: "fotoDag6") // Resim dosyanızın adı
           backgroundImage.contentMode = .scaleAspectFill
           backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        //backgroundImage.alpha = 5
           view.addSubview(backgroundImage)
           view.sendSubviewToBack(backgroundImage) // Resmi diğer öğelerin arkasına gönder

           // Arka plan resmi için Auto Layout
           NSLayoutConstraint.activate([
               backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
               backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])


        let searchBar = UISearchBar()
        searchBar.placeholder = "Ara"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage() // Arka plan şeffaf

        // Büyüteç simgesini beyaz yapmak
        if let textField = searchBar.searchTextField as? UITextField {
            // Büyüteç simgesini beyaz yapmak
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate) // Renk özelleştirme için
                leftView.tintColor = .white // Büyüteç simgesini beyaz yap
            }

            // Arama alanındaki metni beyaz yapmak
            textField.textColor = .white // Kullanıcı yazısını beyaz yap
            
            // Placeholder metnini beyaz yapmak
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white // Placeholder yazısının rengini beyaz yap
            ]
            textField.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? "", attributes: attributes)
        }

        // Arama çubuğunun arka planını siyah yapmak
        searchBar.searchTextField.backgroundColor = .black // Arama alanının arka plan rengini siyah yap

        view.addSubview(searchBar)

        
        
//        searchBar.placeholder = "Ara"
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
//        searchBar.backgroundImage = UIImage()
        
       // searchBar.barTintColor = .black // Bar'ın arka plan rengini siyah yapıyoruz
        //searchBar.backgroundColor = .black // Arka planın renk kodunu belirliyoruz
        
       // Arama çubuğunun içindeki metin alanının arka planını değiştirme
//       if let textField = searchBar.value(forKey: "searchField") as? UITextField {
//           textField.backgroundColor = .black // Arama alanının rengini beyaz yapıyoruz
//       }
        // Sol taraftaki 4 düğme (2x2 düzeninde)
        let buttonTitles = ["Drones", "Flights", "Map Control", "Service"]
        let buttonIcons = ["drone", "airplane.departure", "map", "wrench.and.screwdriver"]
        var buttons: [UIButton] = []

        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setImage(UIImage(systemName: buttonIcons[index]), for: .normal)
            button.tintColor = .white
            button.backgroundColor = .black
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
            button.translatesAutoresizingMaskIntoConstraints = false
            buttons.append(button)
            view.addSubview(button)
        }

        // Sağdaki siyah alan (Collection View ekleniyor)
        let rightView = UIView()
        rightView.backgroundColor = .black
        rightView.layer.cornerRadius = 10
        rightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightView)

        // Collection View Layout (Birden fazla yatay hücre)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal  // Yatay kaydırma
        layout.itemSize = CGSize(width: view.frame.width / 2 - 32, height: 300)  // Hücrelerin genişliğini azaltma
        layout.minimumLineSpacing = 0  // Hücreler arasındaki mesafe

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false  // Sayfalar arasında kaymayı devre dışı bırakıyoruz
        rightView.addSubview(collectionView)

        // Alt taraftaki "Album" ve "Profile" butonları
        let albumButton = UIButton(type: .system)
        albumButton.setTitle("Album", for: .normal)
        albumButton.setImage(UIImage(systemName: "photo"), for: .normal)
      
        albumButton.tintColor = .black
        albumButton.setTitleColor(.black, for: .normal)
        albumButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(albumButton)

        let profileButton = UIButton(type: .system)
        profileButton.setTitle("Profile", for: .normal)
        profileButton.setImage(UIImage(systemName: "person"), for: .normal)
        profileButton.tintColor = .black
      
        profileButton.setTitleColor(.black, for: .normal)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)

        // Alt taraftaki "Bağlan" butonu
        let connectButton = UIButton(type: .system)
        connectButton.setTitle("Bağlan", for: .normal)
        connectButton.tintColor = .white
        connectButton.backgroundColor = .black
        connectButton.layer.cornerRadius = 10
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)

        // Auto Layout
        NSLayoutConstraint.activate([
            // Arama çubuğu
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -2),
                //searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),  // Orta hizalama
            searchBar.widthAnchor.constraint(equalToConstant: 300),  // Sabit genişlik
                //searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -50),

            // Soldaki butonlar (2x2 düzeni)
            buttons[0].topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttons[0].widthAnchor.constraint(equalToConstant: 100),
            buttons[0].heightAnchor.constraint(equalToConstant: 100),

            buttons[1].topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            buttons[1].leadingAnchor.constraint(equalTo: buttons[0].trailingAnchor, constant: 16),
            buttons[1].widthAnchor.constraint(equalToConstant: 100),
            buttons[1].heightAnchor.constraint(equalToConstant: 100),

            buttons[2].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 16),
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttons[2].widthAnchor.constraint(equalToConstant: 100),
            buttons[2].heightAnchor.constraint(equalToConstant: 100),

            buttons[3].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 16),
            buttons[3].leadingAnchor.constraint(equalTo: buttons[2].trailingAnchor, constant: 16),
            buttons[3].widthAnchor.constraint(equalToConstant: 100),
            buttons[3].heightAnchor.constraint(equalToConstant: 100),

            // Sağdaki siyah alan
            rightView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            rightView.leadingAnchor.constraint(equalTo: buttons[1].trailingAnchor, constant: 16),
            rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rightView.bottomAnchor.constraint(equalTo: buttons[3].bottomAnchor),

            // Collection View (Sağdaki siyah alana ekledik)
            collectionView.topAnchor.constraint(equalTo: rightView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor),

            // Alt taraftaki "Album" butonu
            albumButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6),
            albumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 300),

            // Alt taraftaki "Profile" butonu
            profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -600),

            // "Bağlan" butonu
            connectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            connectButton.widthAnchor.constraint(equalToConstant: 200),
            connectButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        // Drones butonuna tıklama aksiyonu
                let dronesButton = buttons[0]  // Drones butonunun index'ine göre seçilir
                dronesButton.addTarget(self, action: #selector(dronesButtonTapped), for: .touchUpInside)
    }
   
    
    private func setupLogoutButton() {
        // Logout düğmesi
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(systemName: "power"), for: .normal) // "power" SF Symbol simgesi
        logoutButton.tintColor = .white
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        logoutButton.backgroundColor = .black
        logoutButton.layer.cornerRadius = 10
        view.addSubview(logoutButton)

        // Logo
        let logoBook = UIButton(type: .system)
        logoBook.setImage(UIImage(systemName: "book"),for: .normal)
        logoBook.tintColor = .white
        logoBook.backgroundColor = .black
        logoBook.layer.cornerRadius = 10
        logoBook.translatesAutoresizingMaskIntoConstraints=false

        view.addSubview(logoBook)

        // Auto Layout Kısıtlamaları
        NSLayoutConstraint.activate([
            // Logout butonu yerleşimi
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 40), // Simge genişliği
            logoutButton.heightAnchor.constraint(equalToConstant: 40), // Simge yüksekliği

            // Logo yerleşimi
            logoBook.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor), // Logout butonuyla aynı hizada
            logoBook.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -8), // Logout butonunun solunda boşluk
            logoBook.widthAnchor.constraint(equalToConstant: 40), // Logo genişliği
            logoBook.heightAnchor.constraint(equalToConstant: 40) // Logo yüksekliği
        ])
    }


    @objc private func logoutAction() {
        do {
            try Auth.auth().signOut()
            if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        } catch let error {
            print("Logout error: \(error.localizedDescription)")
        }
    }
    @objc private func settingsAction() {
        let settingsVC = EditProfileController()
           self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    @objc func dronesButtonTapped() {
           let droneViewController = DroneViewController() // Drone view controller'ını oluştur
           navigationController?.pushViewController(droneViewController, animated: true)  // Drone view controller'ına geçiş yap
       }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count  // Örneğin 10 hücreyi yatay olarak gösterelim
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Custom hücreyi kullanma
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])
        return cell
    }
}














/*

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white

            // Arama çubuğu
            let searchBar = UISearchBar()
            searchBar.placeholder = "Ara"
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(searchBar)

            // Sol taraftaki 4 düğme (2x2 düzeninde)
            let buttonTitles = ["Drones", "Flights", "Map Control", "Service"]
            let buttonIcons = ["airplane", "airplane.departure", "map", "wrench.and.screwdriver"]
            var buttons: [UIButton] = []

            for (index, title) in buttonTitles.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.setImage(UIImage(systemName: buttonIcons[index]), for: .normal)
                button.tintColor = .white
                button.backgroundColor = .black
                button.layer.cornerRadius = 10
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                button.imageView?.contentMode = .scaleAspectFit
                button.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
                button.translatesAutoresizingMaskIntoConstraints = false
                buttons.append(button)
                view.addSubview(button)
            }

            // Sağdaki siyah alan
            let rightView = UIView()
            rightView.backgroundColor = .black
            rightView.layer.cornerRadius = 10
            rightView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(rightView)

            // Alt taraftaki "Album" ve "Profile" butonları
            let albumButton = UIButton(type: .system)
            albumButton.setTitle("Album", for: .normal)
            albumButton.tintColor = .black
            albumButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(albumButton)

            let profileButton = UIButton(type: .system)
            profileButton.setTitle("Profile", for: .normal)
            profileButton.tintColor = .black
            profileButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(profileButton)

            // Alt taraftaki "Bağlan" butonu
            let connectButton = UIButton(type: .system)
            connectButton.setTitle("Bağlan", for: .normal)
            connectButton.tintColor = .white
            connectButton.backgroundColor = .black
            connectButton.layer.cornerRadius = 10
            connectButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(connectButton)

            // Auto Layout
            NSLayoutConstraint.activate([
                // Arama çubuğu
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
                searchBar.widthAnchor.constraint(equalToConstant: 400), // Arama çubuğu genişliği artırıldı
                searchBar.heightAnchor.constraint(equalToConstant: 40),

                // Soldaki butonlar (2x2 düzeni)
                buttons[0].topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
                buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                buttons[0].widthAnchor.constraint(equalToConstant: 100),
                buttons[0].heightAnchor.constraint(equalToConstant: 100),

                buttons[1].topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
                buttons[1].leadingAnchor.constraint(equalTo: buttons[0].trailingAnchor, constant: 16),
                buttons[1].widthAnchor.constraint(equalToConstant: 100),
                buttons[1].heightAnchor.constraint(equalToConstant: 100),

                buttons[2].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 16),
                buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                buttons[2].widthAnchor.constraint(equalToConstant: 100),
                buttons[2].heightAnchor.constraint(equalToConstant: 100),

                buttons[3].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 16),
                buttons[3].leadingAnchor.constraint(equalTo: buttons[2].trailingAnchor, constant: 16),
                buttons[3].widthAnchor.constraint(equalToConstant: 100),
                buttons[3].heightAnchor.constraint(equalToConstant: 100),

                // Sağdaki siyah alan
                rightView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
                rightView.leadingAnchor.constraint(equalTo: buttons[1].trailingAnchor, constant: 16),
                rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                rightView.bottomAnchor.constraint(equalTo: buttons[3].bottomAnchor),

                // Alt taraftaki "Album" butonu
                albumButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                albumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 300),

                // Alt taraftaki "Profile" butonu
                profileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -600),

                // "Bağlan" butonu
                connectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
               // connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                connectButton.widthAnchor.constraint(equalToConstant: 200),
                connectButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
*/
    
    
    
    
    

/*
class homeview2Controller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var leftCollectionView: LeftCollectionView!  // Sol koleksiyon görünümü
    var rightCollectionView: RightCollectionView! // Sağ koleksiyon görünümü

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // Sol koleksiyon görünümünü başlatıyoruz
        leftCollectionView = LeftCollectionView()
        leftCollectionView.dataSource = self
        leftCollectionView.delegate = self
        view.addSubview(leftCollectionView)
        
        // Sağ koleksiyon görünümünü başlatıyoruz
        rightCollectionView = RightCollectionView()
        rightCollectionView.dataSource = self
        rightCollectionView.delegate = self
        view.addSubview(rightCollectionView)

        // Auto Layout kısıtlamaları
        leftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        rightCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Sol koleksiyon için kısıtlamalar
            leftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            leftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            leftCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            leftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            // Sağ koleksiyon için kısıtlamalar
            rightCollectionView.leadingAnchor.constraint(equalTo: leftCollectionView.trailingAnchor, constant: 16),
            rightCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            rightCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            rightCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    // Koleksiyon görünümü için veri kaynakları ve ayarlar
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == leftCollectionView {
            return 3  // Sol koleksiyon görünümündeki öğe sayısı
        } else {
            return 3  // Sağ koleksiyon görünümündeki öğe sayısı
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == leftCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leftCardCell", for: indexPath) as! leftCardCell
            cell.imageView.image = UIImage(named: "card_image")  // Sol koleksiyon için görsel
            cell.titleLabel.text = "Before You Fly"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RightVideoCell", for: indexPath) as! RightVideoCell
            cell.imageView.image = UIImage(named: "video_thumbnail")  // Sağ koleksiyon için video görseli
            cell.titleLabel.text = "Video Title"
            return cell
        }
    }

    // Koleksiyon hücre boyutlarını ayarlama
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == leftCollectionView {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.width - 32, height: 250)  // Üstteki hücre büyük
            } else {
                return CGSize(width: (collectionView.frame.width - 48) / 2, height: 200)  // Alttaki hücreler daha küçük ve yan yana
            }
        } else {
            return CGSize(width: (collectionView.frame.width - 64) / 3, height: 250)  // Sağ koleksiyon için yatayda 3 hücre, yüksekliği büyük
        }
    }
}*/
