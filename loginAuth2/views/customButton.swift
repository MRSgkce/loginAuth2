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
