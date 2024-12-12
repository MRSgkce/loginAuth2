//
//  FlightDetailViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 12.12.2024.
//
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FlightDetailViewController: UIViewController {
    
    var flight: Flight?
    var userId: String? // Kullanıcı ID'sini buraya alıyoruz
    private let storage = Storage.storage()

    // UITextView ekliyoruz
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isEditable = false // Sadece görüntülemek için
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let flightId = flight?.flightId else {
            print("Flight ID bulunamadı.")
            return
        }
        guard let userId = userId else {
            print("User ID bulunamadı.")
            return
        }
        fetchGNSSData(for: flightId, userId: userId)
        
        setupUI()
    }

    // UI elemanlarını yerleştirme
    private func setupUI() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    private func fetchGNSSData(for flightId: String, userId: String) {
        // Firebase Storage'dan GNSS CSV dosyasını çekmek
        let storageRef = storage.reference().child("users/\(userId)/flights/\(flightId)/gnssData_10f.csv")
        
        // Dosyayı geçici bir dizine indir
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(flightId)_gnss.csv")
        
        storageRef.write(toFile: tempURL) { url, error in
            if let error = error {
                // Hata mesajını loglayın
                print("CSV dosyası indirilemedi: \(error.localizedDescription)")
            } else if let url = url {
                // Dosyanın indirildiğini kontrol edin
                print("CSV dosyası indirildi: \(url.path)")
                self.processCSVFile(at: url)
            }
        }
    }

    private func processCSVFile(at url: URL) {
        // CSV dosyasını işlemek için bir fonksiyon
        do {
            let csvData = try String(contentsOf: url, encoding: .utf8)
            let rows = csvData.components(separatedBy: "\n")
            
            var formattedText = ""
            for row in rows {
                let columns = row.components(separatedBy: ",")
                formattedText += columns.joined(separator: " | ") + "\n"
            }
            
            // Verileri textView'a yazdırma
            DispatchQueue.main.async {
                self.textView.text = formattedText
            }
        } catch {
            print("CSV dosyası işlenemedi: \(error.localizedDescription)")
        }
    }
}
