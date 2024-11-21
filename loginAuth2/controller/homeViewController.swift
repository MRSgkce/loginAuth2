//
//  homeViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class homeViewController: UIViewController {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "defaultProfileImage") // Varsayılan profil resmi
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Profil"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserData()
    }


    
    private func createButton(title: String, imageName: String, action: Selector) -> UIButton {
           let button = UIButton(type: .system)
           button.setTitle(title, for: .normal)
           button.setImage(UIImage(systemName: imageName), for: .normal)
           button.addTarget(self, action: action, for: .touchUpInside)
           button.contentHorizontalAlignment = .left
           return button
       }
       
       private func fetchUserData() {
           authService.shared.fetchUser { [weak self] user, error in
               guard let self = self else { return }
               if let error = error {
                   // Hata durumunda uyarı göster
                   alertManager.fetchingerror(on: self, with: error)
                   return
               }
               
               if let user = user {
                   DispatchQueue.main.async {
                       self.nameLabel.text = user.username
                       self.loadProfileImage(from: user.profileImageUrl)
                   }
               }
           }
       }
       
       private func loadProfileImage(from urlString: String?) {
           guard let urlString = urlString, let url = URL(string: urlString) else {
               self.profileImageView.image = UIImage(named: "defaultProfileImage")
               return
           }
           
           let storageRef = Storage.storage().reference(forURL: urlString)
           storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
               if let error = error {
                   print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                   DispatchQueue.main.async {
                       self.profileImageView.image = UIImage(named: "defaultProfileImage")
                   }
               } else if let data = data, let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       self.profileImageView.image = image
                   }
               } else {
                   DispatchQueue.main.async {
                       self.profileImageView.image = UIImage(named: "defaultProfileImage")
                   }
               }
           }
       }
    private func setup() {
        self.view.backgroundColor = .white
        
    
 
        
        

                // Profil resmini ve ismi stackview'e ekliyoruz
                profileStackView.addArrangedSubview(profileImageView)
                profileStackView.addArrangedSubview(nameLabel)

                // StackView'ı view'a ekliyoruz
                self.view.addSubview(profileStackView)

        
        // Profil resmini view'a ekliyoruz
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
               nameLabel.translatesAutoresizingMaskIntoConstraints = false
               profileStackView.translatesAutoresizingMaskIntoConstraints = false

        
        // Ayarlar ve Çıkış Butonları
        let settingsImage = UIImage(systemName: "gear")
        let settingsButton = customButton(title: "Ayarlar", hasBackground: false, fontSize: .med, image: settingsImage)
        settingsButton.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        
        let logoutImage = UIImage(systemName: "arrow.right.square")
        let logoutButton = customButton(title: "Çıkış", hasBackground: false, fontSize: .med, image: logoutImage)
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)

        // Cihaz Yönetimi, Form, Store Butonları
        let deviceManagementImage = UIImage(systemName: "desktopcomputer")
        let deviceManagementButton = customButton(title: "Cihaz", hasBackground: false, fontSize: .med, image: deviceManagementImage)
        deviceManagementButton.addTarget(self, action: #selector(deviceManagementAction), for: .touchUpInside)

        let formImage = UIImage(systemName: "doc.text")
        let formButton = customButton(title: "Form", hasBackground: false, fontSize: .med, image: formImage)
        formButton.addTarget(self, action: #selector(formAction), for: .touchUpInside)

        let storeImage = UIImage(systemName: "cart")
        let storeButton = customButton(title: "Store", hasBackground: false, fontSize: .med, image: storeImage)
        storeButton.addTarget(self, action: #selector(storeAction), for: .touchUpInside)
        
        let bulImage = UIImage(systemName: "magnifyingglass")
        let bulButton = customButton(title: "Bul", hasBackground: false, fontSize: .med, image: bulImage)
        bulButton.addTarget(self, action: #selector(bulAction), for: .touchUpInside)

        // Ayarlar ve Çıkış butonları için StackView (Yatay sıralama)
        let bottomButtonStack = UIStackView(arrangedSubviews: [settingsButton, logoutButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 10
        bottomButtonStack.alignment = .fill // Butonlar genişliği doldurur
        bottomButtonStack.distribution = .fillEqually // Butonlar eşit olarak dağıtılır
        
        // Diğer butonlar için StackView (Dikey sıralama)
        let topButtonStack = UIStackView(arrangedSubviews: [deviceManagementButton, formButton, storeButton, bulButton])
        topButtonStack.axis = .vertical
        topButtonStack.alignment = .fill // Butonlar genişliği doldurur
        topButtonStack.spacing = 25
        topButtonStack.distribution = .fillEqually // Butonlar eşit olarak dağıtılır
        
        // StackView'leri ekliyoruz
        self.view.addSubview(topButtonStack)
        self.view.addSubview(bottomButtonStack)
        
        // Auto Layout kısıtlamaları
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        topButtonStack.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                        profileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                        profileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 130), // Boyut ayarı
                       profileImageView.heightAnchor.constraint(equalToConstant: 130), // Boyut ayarı


//            // Profil resmini konumlandırıyoruz
//            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
//            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
//            profileImageView.widthAnchor.constraint(equalToConstant: 150), // Boyut ayarı
//            profileImageView.heightAnchor.constraint(equalToConstant: 150), // Boyut ayarı

            // Üstteki butonlar stack'i
            topButtonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topButtonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topButtonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Alt butonlar stack'i (Ayarlar ve Çıkış butonları)
            bottomButtonStack.topAnchor.constraint(equalTo: topButtonStack.bottomAnchor, constant: 20), // Aralarına boşluk bırakıyoruz
            bottomButtonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomButtonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])
    }

    // Action metodları
    @objc private func settingsAction() {
        let settingsVC = EditProfileController()
           self.navigationController?.pushViewController(settingsVC, animated: true)
    }

    @objc private func logoutAction() {
        authService.shared.signOut{ [weak self]
                        error in
                        guard let self = self else { return}
                        if let error = error {
                            alertManager.logouterror(on: self, with: error)
                            return
                        }
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    }
    }
    @objc private func bulAction() {
        // Bul butonu aksiyonu
        print("bul butonuna tıklandı")
    }

    @objc private func deviceManagementAction() {
        // Cihaz Yönetimi butonu aksiyonu
        print("Cihaz Yönetimi butonuna tıklandı")
        
        // Drone türlerini tanımla
        let droneTypes = ["Drone A", "Drone B", "Drone C", "Drone D"]
        
        // UIAlertController ile bir aksiyon listesi oluştur
        let alertController = UIAlertController(title: "Drone Türleri", message: "Bir drone türü seçin", preferredStyle: .actionSheet)
        
        // Her bir drone türü için bir aksiyon ekle
        for drone in droneTypes {
            let action = UIAlertAction(title: drone, style: .default) { _ in
                print("\(drone) seçildi")
                // Seçilen drone türüne göre yapılacak işlemleri burada ekleyebilirsiniz
            }
            alertController.addAction(action)
        }
        
        // İptal butonu ekle
        alertController.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        // UIAlertController'ı göster
        present(alertController, animated: true)
    }


    @objc private func formAction() {
        // Form butonu aksiyonu
        print("Form butonuna tıklandı")
    }

    @objc private func storeAction() {
        // Store butonu aksiyonu
        print("Store butonuna tıklandı")
    }
}











    
    //
    //        private func setup() {
    //
    //            self.view.backgroundColor = .white
    //            self.view.addSubview(label)
    //            self.view.addSubview(label2)
    //            self.view.addSubview(imageView2)
    //
    //            NSLayoutConstraint.activate([
    //                label2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    //                label2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //                label2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //                label2.heightAnchor.constraint(equalToConstant: 200), // Yükseklik ayarı
    //
    //                label.topAnchor.constraint(equalTo: label2.topAnchor, constant: 30),
    //            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //            label.heightAnchor.constraint(equalToConstant: 250), // Yükseklik ayarı
    //
    //                imageView2.topAnchor.constraint(equalTo: view.topAnchor,constant: 0), // Üstten 100 birim
    //                        imageView2.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Ortaya hizalama
    //                        imageView2.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1), // Genişlik %50
    //                        imageView2.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1) // Yükseklik, genişlik ile aynı
    //            ])
    //
    //
    //            self.label.translatesAutoresizingMaskIntoConstraints = false
    //            self.label2.translatesAutoresizingMaskIntoConstraints = false
    //            self.imageView2.translatesAutoresizingMaskIntoConstraints = false
    //
    //            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "çıkış",style: .plain,target: self,action: #selector(logout))
    //
    //
    //
    //            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
    //            let largeImage = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: config)
    //
    //            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
    //                image: largeImage,
    //                style: .plain,
    //                target: self,
    //                action: #selector(logout)
    //            )
    //
    //            self.navigationItem.rightBarButtonItem?.tintColor = .black
    //
    ////            let logoImage = UIImage(named: "logo")
    ////            let logoImageView = UIImageView(image: logoImage)
    ////            logoImageView.contentMode = .scaleAspectFit
    ////
    ////            // Görselin boyutunu küçültmek için uygun bir çerçeve ayarlayın
    ////            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60)) // Çerçeve boyutunu belirleyin
    ////            logoImageView.frame = containerView.bounds
    ////            containerView.addSubview(logoImageView)
    ////
    ////            // UIBarButtonItem olarak ekleyin
    ////            let leftBarButton = UIBarButtonItem(customView: containerView)
    ////            self.navigationItem.leftBarButtonItem = leftBarButton
    //
    //
    //
    //
    //
    //
    //        }
    //
    //        @objc private func logout() {
    //            authService.shared.signOut{ [weak self]
    //                error in
    //                guard let self = self else { return}
    //                if let error = error {
    //                    alertManager.logouterror(on: self, with: error)
    //                    return
    //                }
    //                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
    //                    sceneDelegate.checkAuthentication()
    //                }
    //            }
    //        }
    //
    //
    //
    //
    //}

