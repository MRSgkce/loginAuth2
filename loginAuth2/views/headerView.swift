//
//  headerview.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 1.11.2024.
//
import UIKit
class headerView: UIView {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login") // Varsayılan resim
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, subTitle: String, imageName: String) {
        super.init(frame: .zero)
        self.label.text = title
        self.subTitleLabel.text = subTitle
        self.logoImageView.image = UIImage(named: imageName) // Yeni resmi ayarlıyoruz
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.addSubview(logoImageView)
        self.addSubview(label)
        self.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            subTitleLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
