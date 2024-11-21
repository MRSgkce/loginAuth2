//
//  rightVideoCell.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 15.11.2024.
//

import UIKit
import UIKit

class RightVideoCell: UICollectionViewCell {
    // Video için görsel ve başlık etiketini tanımlıyoruz
    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Hücre arka planını ve köşe yuvarlamayı ayarlıyoruz
        backgroundColor = .darkGray
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // Görselin yerleştirilmesi
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // Görselin Auto Layout kısıtlamaları
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Başlık etiketini yerleştiriyoruz
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Başlık etiketinin Auto Layout kısıtlamaları
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
