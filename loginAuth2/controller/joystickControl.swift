import UIKit
import FirebaseAuth
import FirebaseDatabase

class joystickControl: UIViewController {
    
    var flight: Flight?  // Seçilen uçuş verisi
    var userId: String?  // Kullanıcı ID
    
    private let flightInfoStackView = UIStackView()
    
    // Cisim ve göz yönü göstergesi
    private let movingObject = UIView()
    private let directionIndicator = UIView()
    
    // Joystick'ler
    private let leftJoystick = UIView()
    private let rightJoystick = UIView()
    private let leftJoystickButton = UIView()
    private let rightJoystickButton = UIView()

    // Derece etiketleri
    private let yawLabel = UILabel()
    private let pitchLabel = UILabel()
    
    // Sol joystick için dereceler
    private let horizontalDegreeLabel = UILabel()
    private let verticalDegreeLabel = UILabel()
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        ref = Database.database().reference() // Firebase Realtime Database reference
        
        // Kullanıcı ID'sini almak
        self.userId = Auth.auth().currentUser?.uid
        
        setupFlightInfo()
        setupUI()
        setupDegreeLabels()
    }
    
    // 📌 Üstte StackView ile uçuş bilgilerini gösterme
    private func setupFlightInfo() {
        flightInfoStackView.axis = .horizontal
        flightInfoStackView.distribution = .equalSpacing
        flightInfoStackView.alignment = .center
        flightInfoStackView.spacing = 20
        flightInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        let flightIdLabel = createInfoLabel(text: "Flight ID: \(flight?.flightId ?? "Unknown")")
        let altitudeLabel = createInfoLabel(text: "Altitude: \(flight?.altitudeM ?? 0) m")
        let distanceLabel = createInfoLabel(text: "Distance: \(flight?.distanceM ?? 0) m")
        let durationLabel = createInfoLabel(text: "Duration: \(flight?.durationS ?? 0) s")

        flightInfoStackView.addArrangedSubview(flightIdLabel)
        flightInfoStackView.addArrangedSubview(altitudeLabel)
        flightInfoStackView.addArrangedSubview(distanceLabel)
        flightInfoStackView.addArrangedSubview(durationLabel)

        view.addSubview(flightInfoStackView)

        NSLayoutConstraint.activate([
            flightInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            flightInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            flightInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createInfoLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }

    private func setupUI() {
        // Cisim (Hareket eden nesne)
        movingObject.frame = CGRect(x: view.center.x - 25, y: view.center.y - 25, width: 50, height: 50)
        movingObject.backgroundColor = .blue
        movingObject.layer.cornerRadius = 10
        view.addSubview(movingObject)
        
        // Yön göstergesi
        directionIndicator.frame = CGRect(x: movingObject.frame.midX - 5, y: movingObject.frame.minY - 20, width: 10, height: 20)
        directionIndicator.backgroundColor = .red
        directionIndicator.layer.cornerRadius = 5
        view.addSubview(directionIndicator)
        
        // Sol joystick (Arkaplan)
        leftJoystick.frame = CGRect(x: 50, y: view.frame.height - 200, width: 100, height: 100)
        leftJoystick.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        leftJoystick.layer.cornerRadius = 50
        view.addSubview(leftJoystick)
        
        // Sol joystick düğmesi
        leftJoystickButton.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        leftJoystickButton.backgroundColor = .black
        leftJoystickButton.layer.cornerRadius = 25
        leftJoystick.addSubview(leftJoystickButton)
        
        // Sağ joystick (Arkaplan)
        rightJoystick.frame = CGRect(x: view.frame.width - 150, y: view.frame.height - 200, width: 100, height: 100)
        rightJoystick.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        rightJoystick.layer.cornerRadius = 50
        view.addSubview(rightJoystick)
        
        // Sağ joystick düğmesi
        rightJoystickButton.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        rightJoystickButton.backgroundColor = .black
        rightJoystickButton.layer.cornerRadius = 25
        rightJoystick.addSubview(rightJoystickButton)

        // Joystick hareketlerini tanımla
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftJoystick(_:)))
        leftJoystickButton.addGestureRecognizer(leftPan)
        
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(handleRightJoystick(_:)))
        rightJoystickButton.addGestureRecognizer(rightPan)
    }
    
    // 📍 Derece etiketlerini ekleyelim
    private func setupDegreeLabels() {
        yawLabel.frame = CGRect(x: view.center.x - 100, y: view.frame.height - 120, width: 200, height: 20)
        yawLabel.textColor = .white
        yawLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        yawLabel.textAlignment = .center
        view.addSubview(yawLabel)
        
        pitchLabel.frame = CGRect(x: view.center.x - 100, y: view.frame.height - 90, width: 200, height: 20)
        pitchLabel.textColor = .white
        pitchLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        pitchLabel.textAlignment = .center
        view.addSubview(pitchLabel)
        
        // Sol joystick için yeni dereceler
        horizontalDegreeLabel.frame = CGRect(x: view.center.x - 100, y: view.frame.height - 60, width: 200, height: 20)
        horizontalDegreeLabel.textColor = .white
        horizontalDegreeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        horizontalDegreeLabel.textAlignment = .center
        view.addSubview(horizontalDegreeLabel)
        
        verticalDegreeLabel.frame = CGRect(x: view.center.x - 100, y: view.frame.height - 30, width: 200, height: 20)
        verticalDegreeLabel.textColor = .white
        verticalDegreeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        verticalDegreeLabel.textAlignment = .center
        view.addSubview(verticalDegreeLabel)
    }

    // 🎮 Sol joystick hareketi -> Nesneyi hareket ettirir
    @objc private func handleLeftJoystick(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: leftJoystick)
        
        switch gesture.state {
        case .changed:
            let maxRange: CGFloat = 30
            let clampedX = max(-maxRange, min(translation.x, maxRange))
            let clampedY = max(-maxRange, min(translation.y, maxRange))
            
            leftJoystickButton.transform = CGAffineTransform(translationX: clampedX, y: clampedY)
            
            let newX = movingObject.center.x + clampedX * 0.1
            let newY = movingObject.center.y + clampedY * 0.1
            
            movingObject.center = CGPoint(x: newX, y: newY)
            directionIndicator.center = CGPoint(x: newX, y: newY - 20)
            
            // Sol joystick için derece hesaplamaları
            let horizontal = atan2(translation.x, translation.y) * (180 / .pi)
            let vertical = atan2(translation.y, translation.x) * (180 / .pi)
            
            horizontalDegreeLabel.text = "Horizontal: \(Int(horizontal))°"
            verticalDegreeLabel.text = "Vertical: \(Int(vertical))°"
            
            // Realtime Database'e joystick verisini kaydet
            saveJoystickData(yaw: Int(horizontal), pitch: Int(vertical), horizontal: Int(horizontal), vertical: Int(vertical))
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.3) {
                self.leftJoystickButton.transform = .identity
            }
        default:
            break
        }
    }
    
    // 🎮 Sağ joystick hareketi -> Bakış yönünü değiştirir
    @objc private func handleRightJoystick(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: rightJoystick)
        
        let angle = atan2(translation.y, translation.x)
        
        // Yatay ve dikey açı hesaplamaları
        let yaw = angle * (180 / .pi)  // Radyan -> Derece dönüşümü
        let pitch = atan2(translation.x, translation.y) * (180 / .pi)
        
        yawLabel.text = "Yaw: \(Int(yaw))°"
        pitchLabel.text = "Pitch: \(Int(pitch))°"
        
        // Realtime Database'e joystick verisini kaydet
        saveJoystickData(yaw: Int(yaw), pitch: Int(pitch), horizontal: Int(yaw), vertical: Int(pitch))
        
        switch gesture.state {
        case .changed:
            rightJoystickButton.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
            UIView.animate(withDuration: 0.1) {
                self.directionIndicator.transform = CGAffineTransform(rotationAngle: angle)
            }
            
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.3) {
                self.rightJoystickButton.transform = .identity
            }
        default:
            break
        }
    }
    
    // Realtime Database'e joystick verilerini kaydet
    private func saveJoystickData(yaw: Int, pitch: Int, horizontal: Int, vertical: Int) {
        guard let userId = self.userId else {
            print("Kullanıcı doğrulaması yapılmamış")
            return
        }
        
        let joystickData: [String: Any] = [
            "yaw": yaw,
            "pitch": pitch,
            "horizontal": horizontal,
            "vertical": vertical,
            "timestamp": ServerValue.timestamp()
        ]
        
        // Firebase Realtime Database'e veriyi kaydet
        ref.child("users").child(userId).child("joystickData").childByAutoId().setValue(joystickData) { error, _ in
            if let error = error {
                print("Joystick verisi kaydedilirken hata: \(error.localizedDescription)")
            } else {
                print("Joystick verisi başarıyla kaydedildi")
            }
        }
    }
}

