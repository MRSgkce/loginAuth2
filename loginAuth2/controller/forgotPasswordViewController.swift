//
//  forgotPasswordViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit
import FirebaseAuth

class forgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    private let headerview = headerView(title: "Şifremi Unuttum", subTitle: "şifrenizi sıfırlamak için lütfen e-mail adresinizi girin.")
    
    private let emailField = customTextFields(fieldType: .email)
    
    private let resetPasswordButton = customButton(title: "Şifremi Sıfırla",hasBackground: true,fontSize: .big)

    
    func setup(){
        
        self.view.backgroundColor = .white
        self.view.addSubview(headerview)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        headerview.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 130),
                self.headerview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.headerview.heightAnchor.constraint(equalToConstant: 250),
                self.headerview.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),

                // emailField ayarları
                self.emailField.topAnchor.constraint(equalTo: headerview.bottomAnchor, constant: 11),
                self.emailField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.emailField.heightAnchor.constraint(equalToConstant: 55),
                self.emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),

                // resetPasswordButton ayarları
                self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 11),
                self.resetPasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
                self.resetPasswordButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            ])
    }
    
//    @objc func resetPasswordButtonTapped(){
//        let email = emailField.text!
//        
//        if !validator.isValidEmail(for: email){
//            alertManager.showErrorAlertinvalidemail(on: self)
//            return
//        }
//        
////        authService.shared.forgotPassword(with: email) { [weak self] error in
////            guard let self =  self else { return }
////            if let error = error {
////                alertManager.forgotpassworderror(on: self,with: error)
////                return
////                
////            }
////            alertManager.show
////        }
////        
//        
//    }
    
    
    @objc func resetPasswordButtonTapped() {
        let email = emailField.text!

        // E-posta adresinin doğruluğunu kontrol et
        if !validator.isValidEmail(for: email) {
            alertManager.showErrorAlertinvalidemail(on: self)
            return
        }

        // Firebase üzerinden şifre sıfırlama isteği gönder
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }

            // Hata kontrolü
            if let error = error {
                alertManager.forgotPasswordError(on: self, with: error)
                return
            }

            // Kullanıcıya başarı mesajı göster
            alertManager.showSuccessMessage(on: self, message: "Şifre sıfırlama e-postası başarıyla gönderildi. Lütfen e-postanızı kontrol edin.")
        }
    }

    
}
