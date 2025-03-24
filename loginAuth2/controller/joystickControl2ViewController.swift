//
//  joystickControl2ViewController.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 24.03.2025.
//
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import MapKit
import CoreLocation

class joystickControl2: UIViewController {
    
    // MARK: - Değişkenler
    var flight: Flight?
    var userId: String?
    var flightStartTime: Date?
    
    private let flightInfoStackView = UIStackView()
    private let flightStatusLabel = UILabel()
    private let flightModeLabel = UILabel()
    
    private let batteryImageView = UIImageView()
    private let batteryLabel = UILabel()
    private let gspSignalLabel = UILabel()
    private let gsmSignalStrengthLabel = UILabel()
    private var isCameraMode: Bool = true   // <-- Burada!
    
    
    private let leftJoystick = UIView()
    private let rightJoystick = UIView()
    private let leftJoystickButton = UIView()
    private let rightJoystickButton = UIView()
    
    private let yawLabel = UILabel()
    private let pitchLabel = UILabel()
    
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    
    private let startFlightButton = UIButton()
    private let endFlightButton = UIButton()
    
    private let toggleViewButton = UIButton()
    
    private var ref: DatabaseReference!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        leftJoystick.isUserInteractionEnabled = false
        rightJoystick.isUserInteractionEnabled = false
        
        ref = Database.database().reference()
        self.userId = Auth.auth().currentUser?.uid
        
        setupUI()
        setupDegreeLabels()
        setupLatitudeLongitudeLabels()
        setupStartFlightButton()
        setupEndFlightButton()
        setupToggleViewButton()
        setupBatteryAndSignalLabels()
        setupFlightStatusLabel()
        
        sendFormattedTimestampToFirebase()
        fetchFormattedTimestampFromFirebase()
        fetchJoystickData()
        fetchDroneDataRealtime()
    }
    
    
    // MARK: - UI Kurulumları
    private func setupUI() {
        let joystickSize: CGFloat = 100
        let buttonSize: CGFloat = 50
        
        // Left Joystick (Sol Joystick)
        leftJoystick.frame = CGRect(x: 50, y: view.frame.height - 200, width: joystickSize, height: joystickSize)
        leftJoystick.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        leftJoystick.layer.cornerRadius = joystickSize / 2
        view.addSubview(leftJoystick)
        
        leftJoystickButton.frame = CGRect(
            x: (joystickSize - buttonSize) / 2,
            y: (joystickSize - buttonSize) / 2,
            width: buttonSize,
            height: buttonSize
        )
        leftJoystickButton.backgroundColor = .black
        leftJoystickButton.layer.cornerRadius = buttonSize / 2
        leftJoystick.addSubview(leftJoystickButton)
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftJoystick(_:)))
        leftJoystickButton.addGestureRecognizer(leftPan)
        
        // Right Joystick (Sağ Joystick)
        rightJoystick.frame = CGRect(x: view.frame.width - 150, y: view.frame.height - 200, width: joystickSize, height: joystickSize)
        rightJoystick.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        rightJoystick.layer.cornerRadius = joystickSize / 2
        view.addSubview(rightJoystick)
        
        rightJoystickButton.frame = CGRect(
            x: (joystickSize - buttonSize) / 2,
            y: (joystickSize - buttonSize) / 2,
            width: buttonSize,
            height: buttonSize
        )
        rightJoystickButton.backgroundColor = .black
        rightJoystickButton.layer.cornerRadius = buttonSize / 2
        rightJoystick.addSubview(rightJoystickButton)
        
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(handleRightJoystick(_:)))
        rightJoystickButton.addGestureRecognizer(rightPan)
    }

    
    
    private func setupDegreeLabels() {
        let labelWidth: CGFloat = 200
        let labelHeight: CGFloat = 20
        
        // Yaw (sol joystick bilgisi)
        yawLabel.frame = CGRect(
            x: view.center.x - 100,
            y: view.frame.height - 120,
            width: labelWidth,
            height: labelHeight
        )
        yawLabel.textColor = .white
        yawLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        yawLabel.textAlignment = .center
        yawLabel.text = "LJ → H: --°, V: --°"
        view.addSubview(yawLabel)
        
        // Pitch (sağ joystick bilgisi)
        pitchLabel.frame = CGRect(
            x: view.center.x - 100,
            y: view.frame.height - 90,
            width: labelWidth,
            height: labelHeight
        )
        pitchLabel.textColor = .white
        pitchLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        pitchLabel.textAlignment = .center
        pitchLabel.text = "RJ → H: --°, V: --°"
        view.addSubview(pitchLabel)
    }

    
    
    private func setupLatitudeLongitudeLabels() {
        let labelWidth: CGFloat = 200
        let labelHeight: CGFloat = 20
        
        latitudeLabel.frame = CGRect(x: view.center.x - 100, y: view.frame.height - 100, width: labelWidth, height: labelHeight)
        latitudeLabel.textColor = .white
        latitudeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        latitudeLabel.textAlignment = .center
        view.addSubview(latitudeLabel)
        
        longitudeLabel.frame = CGRect(x: view.center.x - 100, y: view.frame.height - 70, width: labelWidth, height: labelHeight)
        longitudeLabel.textColor = .white
        longitudeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        longitudeLabel.textAlignment = .center
        view.addSubview(longitudeLabel)
    }
    
    private func setupFlightStatusLabel() {
        // Flight Mode Label (sol)
        flightModeLabel.frame = CGRect(
            x: 160,      // Daha sağa götürdük (70 → 100)
            y: 2,       // Daha yukarı aldık (50 → 20)
            width: 150,
            height: 40
        )
        flightModeLabel.text = "Mode: --"
        flightModeLabel.textColor = .white
        flightModeLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(flightModeLabel)
        
        // Flight Status Label (sağ)
        flightStatusLabel.frame = CGRect(
            x: flightModeLabel.frame.maxX + 10, // 10 px sağında başlasın
            y: 2,                              // Aynı hizada dursun
            width: 150,
            height: 40
        )
        flightStatusLabel.text = "Not Flight"
        flightStatusLabel.textColor = .white
        flightStatusLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(flightStatusLabel)
    }

    private func setupBatteryAndSignalLabels() {
        let iconSize: CGFloat = 24
        let labelWidth: CGFloat = 60
        let labelHeight: CGFloat = 20
        let labelSpacing: CGFloat = 8
        
        batteryImageView.frame = CGRect(x: view.frame.width - iconSize - labelWidth - labelSpacing - 10, y: 10, width: iconSize, height: iconSize)
        batteryImageView.contentMode = .scaleAspectFit
        batteryImageView.tintColor = .white
        batteryImageView.image = UIImage(systemName: "battery.100")
        view.addSubview(batteryImageView)
        
        batteryLabel.frame = CGRect(x: batteryImageView.frame.maxX + labelSpacing, y: 10, width: labelWidth, height: labelHeight)
        batteryLabel.textColor = .white
        batteryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(batteryLabel)
        
        gspSignalLabel.frame = CGRect(x: batteryImageView.frame.origin.x - labelWidth - 20, y: 10, width: labelWidth, height: labelHeight)
        gspSignalLabel.textColor = .white
        gspSignalLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(gspSignalLabel)
        
        gsmSignalStrengthLabel.frame = CGRect(x: gspSignalLabel.frame.origin.x - labelWidth - 20, y: 10, width: labelWidth, height: labelHeight)
        gsmSignalStrengthLabel.textColor = .white
        gsmSignalStrengthLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        view.addSubview(gsmSignalStrengthLabel)
    }
    
    private func setupStartFlightButton() {
        let buttonSize: CGFloat = 40
        
        startFlightButton.frame = CGRect(
            x: view.center.x - buttonSize / 2,
            y: view.frame.height - buttonSize - 10,
            width: buttonSize,
            height: buttonSize
        )
        
        // Uçak ikonunu ekle
        let iconImage = UIImage(systemName: "airplane.circle.fill") // veya başka bir ikon
        startFlightButton.setImage(iconImage, for: .normal)
        
        // Sadece beyaz ikon gösterimi
        startFlightButton.tintColor = .white
        
        // Arka planı kaldır
        startFlightButton.backgroundColor = .clear
        
        // Görselin tamamını doldurması için ayarla
        startFlightButton.imageView?.contentMode = .scaleAspectFit
        startFlightButton.contentHorizontalAlignment = .fill
        startFlightButton.contentVerticalAlignment = .fill
        
        // Köşeleri yuvarlama veya ek şekillendirme yok
        startFlightButton.layer.cornerRadius = 0
        startFlightButton.clipsToBounds = false
        
        // Aksiyon ekle
        startFlightButton.addTarget(self, action: #selector(startFlight), for: .touchUpInside)
        
        view.addSubview(startFlightButton)
    }

    
    private func setupEndFlightButton() {
        let buttonSize: CGFloat = 40  // Buton boyutu
        
        endFlightButton.frame = CGRect(
            x: 20,                          // Soldan uzaklık
            y: view.center.y - 60,         // Yukarı taşımak için değer küçüldü
            width: buttonSize,
            height: buttonSize
        )
        
        // İkon ekle
        let iconImage = UIImage(systemName: "airplane.arrival")
        endFlightButton.setImage(iconImage, for: .normal)
        
        endFlightButton.tintColor = .white
        endFlightButton.backgroundColor = .clear
        
        endFlightButton.imageView?.contentMode = .scaleAspectFit
        endFlightButton.contentHorizontalAlignment = .fill
        endFlightButton.contentVerticalAlignment = .fill
        
        endFlightButton.layer.cornerRadius = 0
        endFlightButton.clipsToBounds = false
        
        endFlightButton.addTarget(self, action: #selector(endFlight), for: .touchUpInside)
        endFlightButton.isEnabled = false
        
        view.addSubview(endFlightButton)
    }


    
    private func setupToggleViewButton() {
        let buttonSize: CGFloat = 60
        toggleViewButton.frame = CGRect(x: 20, y: view.frame.height - buttonSize - 30, width: buttonSize, height: buttonSize)
        toggleViewButton.setTitle("📷", for: .normal)
        toggleViewButton.backgroundColor = .clear
        toggleViewButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        toggleViewButton.addTarget(self, action: #selector(toggleViewButtonTapped), for: .touchUpInside)
        view.addSubview(toggleViewButton)
    }
    @objc private func toggleViewButtonTapped() {
        isCameraMode.toggle() // true/false değiştiriyoruz
        
        if isCameraMode {
            toggleViewButton.setTitle("📷", for: .normal)
            print("Kamera görünümüne geçildi!")
            // Buraya kamerayı gösteren kod eklenir
        } else {
            toggleViewButton.setTitle("🗺️", for: .normal)
            print("Harita görünümüne geçildi!")
            // Buraya haritayı gösteren kod eklenir
        }
    }

    // MARK: - Uçuş Fonksiyonları
    
    @objc private func startFlight() {
        flightStartTime = Date()
        leftJoystick.isUserInteractionEnabled = true
        rightJoystick.isUserInteractionEnabled = true
        endFlightButton.isEnabled = true
        startFlightButton.isEnabled = false
        flightStatusLabel.text = "In Flight"
    }
    
    @objc private func endFlight() {
        guard let startTime = flightStartTime else { return }
        
        let flightDuration = Int(Date().timeIntervalSince(startTime))
        saveFlightData(flightDuration: flightDuration)
        
        leftJoystick.isUserInteractionEnabled = false
        rightJoystick.isUserInteractionEnabled = false
        startFlightButton.isEnabled = true
        endFlightButton.isEnabled = false
        flightStatusLabel.text = "Not Flight"
    }
    
    private func saveFlightData(flightDuration: Int) {
        guard let userId = self.userId else { return }
        
        let flightData: [String: Any] = [
            "altitudeM": 500,
            "distanceM": 2000,
            "droneId": "7ljzbO7wq6QqCYzUgWsI",
            "durationS": flightDuration,
            "flightStartTime": Timestamp(date: flightStartTime!),
            "ownerId": userId,
            "typeId": "zjrOvIvy0XSFMkdRJmOu"
        ]
        
        let db = Firestore.firestore()
        db.collection("flights").addDocument(data: flightData) { error in
            if let error = error {
                print("Uçuş verileri kaydedilirken hata: \(error.localizedDescription)")
            } else {
                print("Uçuş verileri kaydedildi.")
            }
        }
    }
    
    // MARK: - Firebase Dinleme
    
    private func fetchDroneDataRealtime() {
        guard let userId = self.userId else { return }
        
        ref.child("users").child(userId).child("droneData").observe(.value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            DispatchQueue.main.async {
                if let battery = data["battery"] as? Int,
                   let gpsSignal = data["gsmSignal"] as? Int,
                   let gsmSignalStrength = data["gsmSignalStrength"] as? Int {
                    
                    self.batteryLabel.text = "\(battery)%"
                    
                    var batteryIconName = "battery.100"
                    switch battery {
                    case 80...100: batteryIconName = "battery.100"
                    case 60..<80: batteryIconName = "battery.75"
                    case 40..<60: batteryIconName = "battery.50"
                    case 20..<40: batteryIconName = "battery.25"
                    default: batteryIconName = "battery.0"
                    }
                    
                    self.batteryImageView.image = UIImage(systemName: batteryIconName)
                    self.batteryImageView.tintColor = battery <= 20 ? .red : .white
                    
                    if let flightMode = data["flightMode"] as? String {
                        self.flightModeLabel.text = "Mode: \(flightMode)"
                    } else {
                        self.flightModeLabel.text = "Mode: --"
                    }
                    
                    self.gspSignalLabel.text = "GPS: \(gpsSignal)"
                    self.gsmSignalStrengthLabel.text = "GSM: \(gsmSignalStrength)"
                }
            }
        }
    }
    
    // MARK: - Joystick Hareketleri
    
    @objc private func handleLeftJoystick(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: leftJoystick)
        let horizontal = atan2(translation.x, translation.y) * (180 / .pi)
        let vertical = atan2(translation.y, translation.x) * (180 / .pi)
        
        calculateCoordinates(horizontal: Int(horizontal), vertical: Int(vertical))
        updateJoystickData(isLeftJoystick: true, horizontal: Int(horizontal), vertical: Int(vertical))
    }
    
    @objc private func handleRightJoystick(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: rightJoystick)
        let yaw = atan2(translation.y, translation.x) * (180 / .pi)
        let pitch = atan2(translation.x, translation.y) * (180 / .pi)
        
        calculateCoordinates(horizontal: Int(yaw), vertical: Int(pitch))
        updateJoystickData(isLeftJoystick: false, horizontal: Int(yaw), vertical: Int(pitch))
    }
    
    private func calculateCoordinates(horizontal: Int, vertical: Int) {
        // Burada latitude ve longitude değerlerini hesaplıyoruz
    }
    
    private func updateJoystickData(isLeftJoystick: Bool, horizontal: Int, vertical: Int) {
        guard let userId = self.userId else { return }
        
        let joystickData: [String: Any] = [
            "degreeHort": horizontal,
            "degreeVert": vertical,
            "time": getFormattedCurrentDate()
        ]
        
        let joystickPath = isLeftJoystick ? "LJ" : "RJ"
        
        ref.child("users").child(userId).child("userData/\(joystickPath)").setValue(joystickData)
    }
    
    

    
    // Kullanıcının uçuş başlama zamanını Firebase'e kaydeder
    private func sendFormattedTimestampToFirebase() {
        guard let userId = self.userId else {
            print("Kullanıcı doğrulaması yapılmamış")
            return
        }

        let userTimeRef = ref.child("users").child(userId).child("userData").child("time")

        // Zaman zaten kayıtlı mı kontrol ediyoruz
        userTimeRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("Zaman zaten kayıtlı: \(snapshot.value ?? "Bilinmeyen")")
            } else {
                let formattedDate = self.getFormattedCurrentDate()
                userTimeRef.setValue(formattedDate) { error, _ in
                    if let error = error {
                        print("Zaman gönderilirken hata: \(error.localizedDescription)")
                    } else {
                        print("Zaman başarıyla kaydedildi: \(formattedDate)")
                    }
                }
            }
        }
    }

    // Firebase'den kaydedilmiş zamanı çeker ve ekrana yazar
    private func fetchFormattedTimestampFromFirebase() {
        guard let userId = self.userId else {
            print("Kullanıcı doğrulaması yapılmamış")
            return
        }

        let userTimeRef = ref.child("users").child(userId).child("userData").child("time")

        userTimeRef.observeSingleEvent(of: .value) { snapshot in
            if let formattedTimestamp = snapshot.value as? String {
                DispatchQueue.main.async {
                    // Burada istediğin label'a gösterebilirsin
                    self.yawLabel.text = "Uçuş Başlama Saati: \(formattedTimestamp)"
                }
                print("Zaman başarıyla çekildi: \(formattedTimestamp)")
            } else {
                print("Zaman verisi bulunamadı.")
            }
        }
    }

    // Joystick verilerini Firebase'den çeker ve ekranda gösterir
    private func fetchJoystickData() {
        guard let userId = self.userId else {
            print("Kullanıcı doğrulaması yapılmamış")
            return
        }

        ref.child("users").child(userId).child("userData").observe(.value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {
                print("Kullanıcı verileri bulunamadı.")
                return
            }

            let leftJoystickData = data["LJ"] as? [String: Any]
            let rightJoystickData = data["RJ"] as? [String: Any]

            let leftHorizontal = leftJoystickData?["degreeHort"] as? Int ?? 0
            let leftVertical = leftJoystickData?["degreeVert"] as? Int ?? 0

            let rightHorizontal = rightJoystickData?["degreeHort"] as? Int ?? 0
            let rightVertical = rightJoystickData?["degreeVert"] as? Int ?? 0

            DispatchQueue.main.async {
                self.yawLabel.text = "LJ → H: \(leftHorizontal)°, V: \(leftVertical)°"
                self.pitchLabel.text = "RJ → H: \(rightHorizontal)°, V: \(rightVertical)°"
            }

            print("Joystick verileri çekildi - LJ: H \(leftHorizontal), V \(leftVertical) | RJ: H \(rightHorizontal), V \(rightVertical)")
        }
    }

    // Tarihi biçimlendiren fonksiyon (zaten vardı ama buraya ekliyorum)
    private func getFormattedCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: Date())
    }

}
