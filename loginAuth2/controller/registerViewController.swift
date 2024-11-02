//
//  registerViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit

class registerViewController: UIViewController {
    
    
    private let headerview = headerView(title: "kayıt ol", subTitle: "bilgileri giriniz")
    
    private let tekrargirisButonu = customButton(title: "zaten hesabın var giriş yap", hasBackground :false, fontSize: .med)
    
    private let yenikayitim = customButton(title: "yeni kayit ol", hasBackground :true, fontSize: .big)
    

    
    private let usernameTextField = customTextFields(fieldType: .username)
    private let passwordTextField = customTextFields(fieldType: .password)
    private let emailTextField = customTextFields(fieldType: .email)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        self.tekrargirisButonu.addTarget(self, action: #selector(tekrargirisButonuTapped), for: .touchUpInside)
        
        self.yenikayitim.addTarget(self, action: #selector(yenikayitButonuTapped), for: .touchUpInside)
    }
    
    @objc private func tekrargirisButonuTapped() {
        let vc = loginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc private func yenikayitButonuTapped() {
        print("yeni kayit oldum")    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUp() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerview)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(tekrargirisButonu)
        self.view.addSubview(yenikayitim)
        //self.view.addSubview(unuttum)
        
        self.headerview.translatesAutoresizingMaskIntoConstraints = false
        self.usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.tekrargirisButonu.translatesAutoresizingMaskIntoConstraints = false
        self.yenikayitim.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            headerview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerview.heightAnchor.constraint(equalToConstant: 250), // Yükseklik ayarı

            usernameTextField.topAnchor.constraint(equalTo: headerview.bottomAnchor, constant: 50),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            yenikayitim.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
            yenikayitim.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yenikayitim.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            yenikayitim.heightAnchor.constraint(equalToConstant: 50),
            
            tekrargirisButonu.topAnchor.constraint(equalTo: yenikayitim.bottomAnchor, constant: 11),
            tekrargirisButonu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tekrargirisButonu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            tekrargirisButonu.heightAnchor.constraint(equalToConstant: 30)
            
           
        ])
    }
}
