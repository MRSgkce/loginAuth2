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
            NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 250), // Yükseklik ayarı
            ])
            self.label.translatesAutoresizingMaskIntoConstraints = false
          
            
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "çıkış",style: .plain,target: self,action: #selector(logout))
       
           
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
