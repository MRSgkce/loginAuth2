//
//  homeViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit

class homeViewController: UIViewController {
    
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let label2 : UILabel = {
        let label2 = UILabel()
        label2.text = "kullanıcı adınız ve mailiniz "
        label2.textColor = .black
        label2.textAlignment = .center
        label2.font = .systemFont(ofSize: 28, weight: .semibold)
        return label2
    }()
    
    private let imageView2: UIImageView = {
        let imageView22 = UIImageView()
        imageView22.image = UIImage(named: "dji") // "dji" adıyla resmi yükleyin
           imageView22.contentMode = .scaleAspectFill // Görüntüyü tam kaplamak için
           imageView22.translatesAutoresizingMaskIntoConstraints = false // Auto Layout kullanmak için
           imageView22.alpha = 0.6 // Şeffaflık değeri (0.0 ile 1.0 arasında)
           return imageView22
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        authService.shared.fetchUser{ [weak self] user , error in
            guard let self = self else{ return}
            if let error =  error{
                alertManager.fetchingerror(on: self, with: error as! any Error )
                return
            }
            if let user = user {
                self.label.text = "\(user.username) - \(user.email)"
                
            }
            
        }
    }
        
        
        private func setup() {
            
            self.view.backgroundColor = .white
            self.view.addSubview(label)
            self.view.addSubview(label2)
            self.view.addSubview(imageView2)
            
            NSLayoutConstraint.activate([
                label2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                label2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                label2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                label2.heightAnchor.constraint(equalToConstant: 200), // Yükseklik ayarı
                
                label.topAnchor.constraint(equalTo: label2.topAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 250), // Yükseklik ayarı
                
                imageView2.topAnchor.constraint(equalTo: view.topAnchor,constant: 0), // Üstten 100 birim
                        imageView2.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Ortaya hizalama
                        imageView2.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 1), // Genişlik %50
                        imageView2.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 1) // Yükseklik, genişlik ile aynı
            ])
            
            
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label2.translatesAutoresizingMaskIntoConstraints = false
            self.imageView2.translatesAutoresizingMaskIntoConstraints = false
            
            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "çıkış",style: .plain,target: self,action: #selector(logout))
       
    
            
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let largeImage = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: config)

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: largeImage,
                style: .plain,
                target: self,
                action: #selector(logout)
            )

            self.navigationItem.rightBarButtonItem?.tintColor = .black

//            let logoImage = UIImage(named: "logo")
//            let logoImageView = UIImageView(image: logoImage)
//            logoImageView.contentMode = .scaleAspectFit
//
//            // Görselin boyutunu küçültmek için uygun bir çerçeve ayarlayın
//            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60)) // Çerçeve boyutunu belirleyin
//            logoImageView.frame = containerView.bounds
//            containerView.addSubview(logoImageView)
//
//            // UIBarButtonItem olarak ekleyin
//            let leftBarButton = UIBarButtonItem(customView: containerView)
//            self.navigationItem.leftBarButtonItem = leftBarButton
          

            
            

           
        }
    
        @objc private func logout() {
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
        
        
        
    
}
