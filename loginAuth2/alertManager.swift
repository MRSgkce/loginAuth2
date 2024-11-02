//
//  alertManager.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit


class alertManager{
    
    private static func showBasicAlert(on vc : UIViewController,title :String,message: String? ){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

extension alertManager{
    static func showErrorAlertinvalidemail(on vc : UIViewController){
        self.showBasicAlert(on: vc,title : "Error", message: "geçerli mail gir")
    }
    
    static func showErrorAlertinvalidpassword(on vc : UIViewController){
        self.showBasicAlert(on: vc,title : "Error", message: "please enter valid password")
    }
    
    static func showErrorAlertinvalidusername(on vc : UIViewController){
        self.showBasicAlert(on: vc,title : "Error", message: "please enter valid username")    }
}

//registraiton error
extension alertManager{
    
    public static func registrationerror(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "bilinmeyenkayıt", message: nil)
    }
    
    public static func registrationerror(on vc: UIViewController,with error: Error){
        self.showBasicAlert(on: vc, title: "bilinmeyenkayıt", message: "\(error.localizedDescription)")
    }
}



//login error
extension alertManager{
    
    public static func loginerror(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "bilinmeyen girişi", message: nil)
    }
    
    public static func loginerror(on vc: UIViewController,with error: Error){
        self.showBasicAlert(on: vc, title: "bilinmeyen giriş", message: "\(error.localizedDescription)")
    }
    
    
}


//log out error
extension alertManager{
    
 
    
    public static func logouterror(on vc: UIViewController,with error: Error){
        self.showBasicAlert(on: vc, title: "log out error", message: "\(error.localizedDescription)")
    }
    
    
}


//forgot password error
extension alertManager{
    
    public static func forgotpassworderror(on vc: UIViewController){
        
        self.showBasicAlert(on: vc, title: "şifremi unuttum sayfa hatası", message: nil)
    }
    
    
    
    public func forgotpassworderror(on vc: UIViewController,with error: Error){
        alertManager.showBasicAlert(on: vc, title: "forgot sayfası error", message: "\(error.localizedDescription)")
        
    }
    
}

//fetching user errors
extension alertManager{
    
    public static func fetchingerror(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "kullanıcıları listeleme hatası", message: nil)
    }
    
    public static func fetchingerror(on vc: UIViewController,with error: Error){
        self.showBasicAlert(on: vc, title: "fetching hatası", message: "\(error.localizedDescription)")
    }
    
}





