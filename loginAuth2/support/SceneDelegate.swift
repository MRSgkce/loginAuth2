//
//  SceneDelegate.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupwindow(with: scene)
        self.checkAuthentication()
        
//        let vc  = loginViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        window.rootViewController = nav
   
//        let userRequest = register(username: "murside", email: "code@gmail.com",password: "123456")
//        
//        authService.shared.registerUser(with: userRequest){
//            wasRegistered,Error in
//            if let error=Error{
//                print(error.localizedDescription)
//                return
//            }
//            print("was regsistered",wasRegistered)
//        }
    }

    private func setupwindow(with scene: UIScene){
        guard let windowScene  = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    
    
   /* public func checkAuthentication(){
        if Auth.auth().currentUser == nil{
            self.foToController(with: loginViewController())
            
        }else{
            self.foToController(with: homeViewController())
        }
    }
    */
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            // Kullanıcı oturum açmamışsa login ekranına geçiş yap ve dikey moda ayarla
            self.foToController(with: loginViewController(), orientation: .portrait)
        } else {
            // Kullanıcı oturum açmışsa ana ekrana geçiş yap ve yatay moda ayarla
            self.foToController(with: homeview2Controller(), orientation: .landscapeLeft)
        }
    }

    
   

    
    /*private func foToController(with viewcontroller : UIViewController){
        DispatchQueue.main.async {[weak self]
            in UIView.animate(withDuration: 0.25){
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
           
                let nav = UINavigationController(rootViewController: viewcontroller)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25){[weak self]
                    in self?.window?.layer.opacity = 1
                    
                }
            }
            
        }
    }*/
    
    private func foToController(with viewcontroller: UIViewController, orientation: UIInterfaceOrientation) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let nav = UINavigationController(rootViewController: viewcontroller)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
                
                // Ekran yönünü belirle
                UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }

}

