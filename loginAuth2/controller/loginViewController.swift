//
//  loginViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit
import UIKit

class loginViewController: UIViewController {
    private let headerview = headerView(title: "HOŞGELDİN", subTitle: "lütfen bilgilerini gir",imageName: "giriss")
    private let girisButonu = customButton(title: "Giriş yap", hasBackground :true, fontSize: .big)
    private let yeniKayit = customButton(title: "Henüz yeni misin ? Hemen kayıt ol", hasBackground :false, fontSize: .med)
    private let unuttum = customButton(title: "Şifremi unuttum", hasBackground :false, fontSize: .small)
    
    private let emailTextField = customTextFields(fieldType: .email)
    private let passwordTextField = customTextFields(fieldType: .password)
    private let usernameTextField = customTextFields(fieldType: .username)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        self.girisButonu.addTarget(self, action: #selector(girisButonuTapped), for: .touchUpInside)
        self.yeniKayit.addTarget(self, action: #selector(yenikayitButonuTapped), for: .touchUpInside)
        self.unuttum.addTarget(self, action: #selector(unuttumButonuTapped), for: .touchUpInside)
    }
    
    @objc private func girisButonuTapped() {
        
        let loginRequest = login(email: emailTextField.text!, password: passwordTextField.text!)
        
    
        
        if !validator.isValidEmail(for: loginRequest.email){
            alertManager.showErrorAlertinvalidemail(on: self)
            return
        }
        
        if !validator.isValidPassword(for: loginRequest.password){
            alertManager.showErrorAlertinvalidpassword(on: self)
            return
        }
        
        authService.shared.signIn(with: loginRequest){
            error in
            if let error = error {
                alertManager.loginerror(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
        
//        let vc = homeViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false, completion: nil)
    }
    
    @objc private func yenikayitButonuTapped() {
        let vc = registerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func unuttumButonuTapped() {
        let vc = forgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    private func setUp() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerview)
        self.view.addSubview(emailTextField)
        //self.view.addSubview(usernameTextField)
       
        self.view.addSubview(passwordTextField)
        self.view.addSubview(girisButonu)
        self.view.addSubview(yeniKayit)
        self.view.addSubview(unuttum)
        
        headerview.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        girisButonu.translatesAutoresizingMaskIntoConstraints = false
        yeniKayit.translatesAutoresizingMaskIntoConstraints = false
        unuttum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            /*headerview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerview.heightAnchor.constraint(equalToConstant: 150), // Yükseklik ayarı

            
            emailTextField.topAnchor.constraint(equalTo: headerview.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
           
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 22),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            girisButonu.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
            girisButonu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            girisButonu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            girisButonu.heightAnchor.constraint(equalToConstant: 50),
            
            yeniKayit.topAnchor.constraint(equalTo: girisButonu.bottomAnchor, constant: 11),
            yeniKayit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yeniKayit.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            yeniKayit.heightAnchor.constraint(equalToConstant: 30),
            
            unuttum.topAnchor.constraint(equalTo: yeniKayit.bottomAnchor, constant: 5),
            unuttum.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unuttum.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            unuttum.heightAnchor.constraint(equalToConstant: 44),*/
            
            headerview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                headerview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerview.heightAnchor.constraint(equalToConstant: 150), // Yükseklik ayarı

                // Email TextField'in yukarısındaki mesafeyi artırarak aşağı kaydırıyoruz
                emailTextField.topAnchor.constraint(equalTo: headerview.bottomAnchor, constant: 40), // 40'tan 60'a çıkardık
                emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90), // Genişliği %90'a çıkarıyoruz
                emailTextField.heightAnchor.constraint(equalToConstant: 60), // Yüksekliği 50'den 60'a çıkarıyoruz
                   
                // Password TextField'in yukarısındaki mesafeyi artırarak aşağı kaydırıyoruz
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40), // 30'dan 40'a çıkardık
                passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90), // Genişliği %90'a çıkarıyoruz
                passwordTextField.heightAnchor.constraint(equalToConstant: 60), // Yüksekliği 50'den 60'a çıkarıyoruz
                
                // Giriş butonunun yukarısındaki mesafeyi artırarak aşağı kaydırıyoruz
                girisButonu.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40), // 30'dan 40'a çıkardık
                girisButonu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                girisButonu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90), // Genişliği %90'a çıkarıyoruz
                girisButonu.heightAnchor.constraint(equalToConstant: 60), // Yüksekliği 50'den 60'a çıkarıyoruz
                
                // Yeni kayıt butonunun yukarısındaki mesafeyi artırarak aşağı kaydırıyoruz
                yeniKayit.topAnchor.constraint(equalTo: girisButonu.bottomAnchor, constant: 30), // 20'den 30'a çıkardık
                yeniKayit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                yeniKayit.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90), // Genişliği %90'a çıkarıyoruz
                yeniKayit.heightAnchor.constraint(equalToConstant: 40), // Yüksekliği 30'dan 40'a çıkarıyoruz
                
                // Unuttum butonunun yukarısındaki mesafeyi artırarak aşağı kaydırıyoruz
                unuttum.topAnchor.constraint(equalTo: yeniKayit.bottomAnchor, constant: 15), // 10'dan 15'e çıkardık
                unuttum.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                unuttum.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90), // Genişliği %90'a çıkarıyoruz
                unuttum.heightAnchor.constraint(equalToConstant: 50),
            ])


    }
}
