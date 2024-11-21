//
//  cell.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 16.11.2024.
//

import UIKit



class DroneTableViewCell: UITableViewCell {

private let droneImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
}()

private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .right // Yazıyı sağa hizalamak için
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

private func setupViews() {
    
    //backgroundColor = .gray
    //contentView.backgroundColor = .gray
    
    layer.cornerRadius = 12
       clipsToBounds = true

    addSubview(droneImageView)
    addSubview(nameLabel)
    
    NSLayoutConstraint.activate([
        // Drone image constraints
        droneImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100), // Daha sağdan başlıyor
        droneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        droneImageView.widthAnchor.constraint(equalToConstant: 50),
        droneImageView.heightAnchor.constraint(equalToConstant: 50),
        
        // Name label constraints
        nameLabel.leadingAnchor.constraint(equalTo: droneImageView.trailingAnchor, constant: 15), // Resim ile yazı arasındaki boşluk artırıldı
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20) // Sağ boşluk azaltıldı
    ])
}

func configure(with droneType: DroneType) {
    nameLabel.text = droneType.name
    loadImage(from: droneType.photoURL)
}

private func loadImage(from urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            print("Error loading cell image: \(error.localizedDescription)")
            return
        }
        
        guard let data = data, let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.droneImageView.image = image
        }
    }.resume()
}
}
