//
//  customButton.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//


import UIKit

class customButton: UIButton {

    enum fontSize {
        case big
        case med
        case small
    }
    
    init(title: String, hasBackground: Bool = false, fontSize: fontSize, image: UIImage? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = hasBackground ? .black : .clear
        let titleColor: UIColor = hasBackground ? .white : .black
        self.setTitleColor(titleColor, for: .normal)

        // Eğer bir resim varsa, butonun sol tarafına ekliyoruz
        if let image = image {
            self.setImage(image, for: .normal)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) // Resmin biraz sola kaydırılması
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // Başlık ile resim arasında mesafe
        }
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        case .med:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



/*
import UIKit

class customButton: UIButton {
    
    enum fontSize {
        case big
        case med
        case small
    }
    init (title:String,hasBackground:Bool = false, fontSize : fontSize){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = hasBackground ? .black : .clear
        
        let titlecolor : UIColor = hasBackground ? .white : .black
        self.setTitleColor(titlecolor, for: .normal)
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        case .med:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
*/
