//
//  loginViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit
import UIKit

class loginViewController: UIViewController {
    private let headerview = headerView(title: "HOŞGELDİN", subTitle: "lütfen bilgilerini gir")
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
            headerview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerview.heightAnchor.constraint(equalToConstant: 200), // Yükseklik ayarı

            
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
            unuttum.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
