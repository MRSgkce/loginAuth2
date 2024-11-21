//
//  editProfileController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 8.11.2024.
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yeni Kullanıcı Adı"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hesabımı Sil", for: .normal)
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserProfile()
    }
    
    // Kullanıcı profilini Firebase'den yükleme
    func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Kullanıcı bilgilerini alma hatası: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot, snapshot.exists else {
                print("Belge mevcut değil!")
                return
            }

            guard let data = snapshot.data() else {
                print("Belge verisi çözülemedi!")
                return
            }

            if let username = data["username"] as? String {
                self.nameTextField.text = username
            } else {
                print("Kullanıcı adı bulunamadı!")
            }

            if let profileImageUrl = data["profileImageUrl"] as? String {
                self.loadProfileImage(from: profileImageUrl)
            } else {
                print("Profil resmi URL'si bulunamadı!")
            }
        }

        
        
        
        
        /*
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Kullanıcı bilgilerini alma hatası: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            if let username = data["username"] as? String {
                self.nameTextField.text = username
            }
            
            if let profileImageUrl = data["profileImageUrl"] as? String {
                self.loadProfileImage(from: profileImageUrl)
            }
        }*/
    }
    
    func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Profil resmi yükleme hatası: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        view.addSubview(deleteAccountButton)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deleteAccountButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc func saveProfile() {
        guard let username = nameTextField.text, !username.isEmpty else {
            print("Kullanıcı adı boş olamaz")
            return
        }
        
        if let image = profileImageView.image, let imageData = image.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
            
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Resim yükleme hatası: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("URL alma hatası: \(error.localizedDescription)")
                        return
                    }
                    
                    self.updateUserProfile(username: username, profileImageUrl: url?.absoluteString)
                }
            }
        } else {
            updateUserProfile(username: username, profileImageUrl: nil)
        }
    }
    
    func updateUserProfile(username: String, profileImageUrl: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var userData: [String: Any] = ["username": username]
        if let profileImageUrl = profileImageUrl {
            userData["profileImageUrl"] = profileImageUrl
        }
        
        Firestore.firestore().collection("users").document(uid).setData(userData, merge: true) { error in
            if let error = error {
                print("Profil güncelleme hatası: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Başarı", message: "Profil başarıyla güncellendi.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func deleteAccount() {
        let alert = UIAlertController(title: "Hesap Sil", message: "Hesabınızı silmek istediğinize emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel))
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { _ in
            self.performAccountDeletion()
        }))
        present(alert, animated: true)
    }
    
    func performAccountDeletion() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                print("Hesap silme hatası: \(error.localizedDescription)")
            } else {
                print("Hesap başarıyla silindi.")
                let loginVC = loginViewController() // Kendi login controller'ınızı ekleyin
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true)
    }
}
