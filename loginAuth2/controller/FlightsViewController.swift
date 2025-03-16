//
//  FlightsViewController.swift
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

class FlightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Üst panel bileşenleri
    private let totalDistanceLabel = UILabel()
    private let totalFlightCountLabel = UILabel()
    private let totalFlightTimeLabel = UILabel()

    // Tablo bileşenleri
    private let tableView = UITableView()
    private var flights: [Flight] = [] // Uçuş verilerini tutacak model
    private let db = Firestore.firestore() // Firestore bağlantısı

    // Header (butonlar) ve Flight Model için StackView
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Date", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()

    private let distanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Distance", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()

    private let durationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Duration", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()

    private let altitudeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Altitude", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupHeaderView()
        setupTableView()
        fetchCurrentUserAndFlights()
    }

    // Üst paneli oluşturma
    private func setupHeaderView() {
        let headerView = UIStackView()
        headerView.axis = .horizontal
        headerView.alignment = .center
        headerView.distribution = .fillEqually
        headerView.spacing = 16
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Total Distance
        totalDistanceLabel.text = "0 m"
        totalDistanceLabel.textColor = .white
        totalDistanceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let totalDistanceStack = createStatView(title: "Total Distance", valueLabel: totalDistanceLabel)
        headerView.addArrangedSubview(totalDistanceStack)

        // Total Flights
        totalFlightCountLabel.text = "0"
        totalFlightCountLabel.textColor = .white
        totalFlightCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let totalFlightCountStack = createStatView(title: "Total Flights", valueLabel: totalFlightCountLabel)
        headerView.addArrangedSubview(totalFlightCountStack)

        // Total Flight Time
        totalFlightTimeLabel.text = "0 s"
        totalFlightTimeLabel.textColor = .white
        totalFlightTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let totalFlightTimeStack = createStatView(title: "Total Flight Time", valueLabel: totalFlightTimeLabel)
        headerView.addArrangedSubview(totalFlightTimeStack)

        view.addSubview(headerView)

        // StackView'ı ve Tabloyu hizalama
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Header StackView'ı ekle
        view.addSubview(headerStackView)

        // HeaderStackView için kısıtlamalar
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerStackView.heightAnchor.constraint(equalToConstant: 40) // Butonlar için daha küçük yükseklik
        ])

        // Butonları Header StackView'a ekle
        headerStackView.addArrangedSubview(dateButton)
        headerStackView.addArrangedSubview(distanceButton)
        headerStackView.addArrangedSubview(durationButton)
        headerStackView.addArrangedSubview(altitudeButton)
    }

    private func createStatView(title: String, valueLabel: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)

        return stackView
    }

    // Tabloyu oluşturma
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FlightCell")
        tableView.backgroundColor = .black
        tableView.separatorColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Firebase'den kullanıcı ve uçuş verilerini çekme
    private func fetchCurrentUserAndFlights() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturum açmamış.")
            return
        }

        // Kullanıcı bilgilerini çek
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Kullanıcı verisi alınırken hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists,
                  let data = document.data(),
                  let totalDistanceM = data["totalDistanceM"] as? Int,
                  let totalFlightCount = data["totalFlightCount"] as? Int,
                  let totalFlightTimes = data["totalFlightTimes"] as? Int else {
                      print("Kullanıcı verisi eksik veya yanlış formatta.")
                      return
                  }

            // Üst paneli güncelle
            DispatchQueue.main.async {
                self.totalDistanceLabel.text = "\(totalDistanceM) m"
                self.totalFlightCountLabel.text = "\(totalFlightCount)"
                self.totalFlightTimeLabel.text = "\(totalFlightTimes) s"
            }

            // Kullanıcının uçuşlarını çek
            self.fetchUserFlights(ownerId: userId)
        }
    }

    private func fetchUserFlights(ownerId: String) {
        db.collection("flights").whereField("ownerId", isEqualTo: ownerId).getDocuments { snapshot, error in
            if let error = error {
                print("Uçuş verileri alınırken hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("Uçuş verisi bulunamadı.")
                return
            }

            self.flights = documents.compactMap { doc -> Flight? in
                let data = doc.data()
                guard let flightId = doc.documentID as? String, // flightId'yi alıyoruz
                      let altitudeM = data["altitudeM"] as? Int,
                      let distanceM = data["distanceM"] as? Int,
                      let durationS = data["durationS"] as? Int,
                      let flightStartTime = data["flightStartTime"] as? Timestamp else {
                          return nil
                      }
                return Flight(flightId: flightId, altitudeM: altitudeM, distanceM: distanceM, durationS: durationS, flightStartTime: flightStartTime)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Seçilen uçuşu al
        let selectedFlight = flights[indexPath.row]
        
        // Yeni bir detay ekranı oluştur ve seçilen uçuşu ilet
       // let detailVC = FlightDetailViewController()
        let detailVC = joystickControl()
        detailVC.flight = selectedFlight
        detailVC.userId = Auth.auth().currentUser?.uid // Kullanıcı ID'sini ilet
        navigationController?.pushViewController(detailVC, animated: true)
        
        // Seçimi kaldır (opsiyonel)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath)
        let flight = flights[indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: flight.flightStartTime.dateValue())

                cell.textLabel?.text = "\(dateString)                  \(flight.distanceM) m                                    \(flight.altitudeM) m                                     \(flight.durationS) s"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
}
