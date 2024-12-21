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
import UIKit
import FirebaseStorage
import MapKit
import UIKit
import FirebaseStorage
import MapKit
import UIKit
import FirebaseStorage
import MapKit
import UIKit
import FirebaseStorage



import UIKit
import FirebaseStorage
import MapKit

class FlightDetailViewController: UIViewController {
    
    var flight: Flight?
    var userId: String?
    private let storage = Storage.storage()
    private var flightDataList: [(latitude: Double, longitude: Double)] = []
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isEditable = false
        return textView
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        return slider
    }()
    
    private var coordinates: [CLLocationCoordinate2D] = []  // Yolu çizeceğimiz koordinatlar listesi
    private var currentIndex = 0
    
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
        
        // MapView delegate'ini ayarla
        mapView.delegate = self
        
        // Slider action'ı ekle
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    // UI elemanlarını yerleştirme
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(textView)
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            
            textView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -16),
            
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // Firebase'den GNSS verisini çekme
    private func fetchGNSSData(for flightId: String, userId: String) {
        let storageRef = storage.reference().child("users/\(userId)/flights/\(flightId)/gnssData_10f.csv")
        
        // Dosyayı geçici bir dizine indir
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(flightId)_gnss.csv")
        
        storageRef.write(toFile: tempURL) { url, error in
            if let error = error {
                print("CSV dosyası indirilemedi: \(error.localizedDescription)")
            } else if let url = url {
                print("CSV dosyası indirildi: \(url.path)")
                self.processCSVFile(at: url)
            }
        }
    }

    // CSV dosyasını işleme
    private func processCSVFile(at url: URL) {
        do {
            let csvData = try String(contentsOf: url, encoding: .utf8)
            let rows = csvData.components(separatedBy: "\n")
            
            var formattedText = ""
            var flightData: [(Double, Double)] = []
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 3, let latitude = Double(columns[1]), let longitude = Double(columns[2]) {
                    flightData.append((latitude, longitude))
                    formattedText += columns.joined(separator: " | ") + "\n"
                }
            }
            
            // Verileri textView'a yazdırma
            DispatchQueue.main.async {
                self.textView.text = formattedText
            }
            
            self.flightDataList = flightData
            
            // Slider'ı uygun şekilde ayarla
            self.slider.maximumValue = Float(flightDataList.count - 1)
            self.slider.value = 0
            
            // Başlangıçta ilk veriyi harita üzerinde göstereceğiz
            self.updateMap(for: 0)
            
        } catch {
            print("CSV dosyası işlenemedi: \(error.localizedDescription)")
        }
    }
    
    // Haritayı güncelleme
    private func updateMap(for index: Int) {
        guard index < flightDataList.count else { return }
        
        let data = flightDataList[index]
        let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        
        // Önceki işaretçileri kaldırıyoruz
        mapView.removeAnnotations(mapView.annotations)
        
        // Yeni işaretçi ekliyoruz
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Konum: \(index + 1)"
        mapView.addAnnotation(annotation)
        
        // Harita bölgesini güncelliyoruz
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Yolu çizmeye devam ediyoruz
        coordinates.append(coordinate)
        drawPathOnMap()
    }

    // Harita üzerinde yol çizme (Poligonun kapanmasını sağlamak)
    private func drawPathOnMap() {
        // Polyline oluşturuyoruz
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        // Overlay olarak ekliyoruz
        mapView.addOverlay(polyline)
    }
    
    // Slider değeri değiştiğinde bu fonksiyon çağrılacak
    @objc private func sliderValueChanged(_ sender: UISlider) {
        currentIndex = Int(sender.value)
        updateMap(for: currentIndex)
    }
}

// MKMapViewDelegate metodunu implement et
extension FlightDetailViewController: MKMapViewDelegate {
    
    // MKMapViewDelegate fonksiyonu ile polyline renderer'ını oluşturuyoruz
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // Özel işaretçi (uçak emoji) ekleme
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKPointAnnotation {
                let reuseId = "airplaneAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKAnnotationView
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    annotationView?.canShowCallout = true
                }
                
                // Uçak emoji'sini büyültüp siyah yapma
                annotationView?.image = UIImage(systemName: "airplane.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
                annotationView?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0) // Uçak simgesini büyütme
                
                return annotationView
            }
            return nil
        }
}







/*
class FlightDetailViewController: UIViewController {
    
    var flight: Flight?
    var userId: String?
    private let storage = Storage.storage()
    private var flightDataList: [(latitude: Double, longitude: Double)] = []
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.isEditable = false
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
        view.addSubview(mapView)
        view.addSubview(slider)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            
            slider.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    // Firebase'den GNSS verisini çekme
    private func fetchGNSSData(for flightId: String, userId: String) {
        let storageRef = storage.reference().child("users/\(userId)/flights/\(flightId)/gnssData_10f.csv")
        
        // Dosyayı geçici bir dizine indir
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(flightId)_gnss.csv")
        
        storageRef.write(toFile: tempURL) { url, error in
            if let error = error {
                print("CSV dosyası indirilemedi: \(error.localizedDescription)")
            } else if let url = url {
                print("CSV dosyası indirildi: \(url.path)")
                self.processCSVFile(at: url)
            }
        }
    }

    // CSV dosyasını işleme
    private func processCSVFile(at url: URL) {
        do {
            let csvData = try String(contentsOf: url, encoding: .utf8)
            let rows = csvData.components(separatedBy: "\n")
            
            var formattedText = ""
            var flightData: [(Double, Double)] = []
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 3, let latitude = Double(columns[1]), let longitude = Double(columns[2]) {
                    flightData.append((latitude, longitude))
                    formattedText += columns.joined(separator: " | ") + "\n"
                }
            }
            
            // Verileri textView'a yazdırma
            DispatchQueue.main.async {
                self.textView.text = formattedText
            }
            
            self.flightDataList = flightData
            self.slider.maximumValue = Float(flightData.count - 1)
            
            // Başlangıçta ilk veriyi harita üzerinde göstereceğiz
            self.updateMap(for: 0)
            
        } catch {
            print("CSV dosyası işlenemedi: \(error.localizedDescription)")
        }
    }
    
    // Slider değeri değiştiğinde çağrılır
    @objc func sliderValueChanged(_ sender: UISlider) {
        let index = Int(sender.value)
        updateMap(for: index)
    }
    
    // Haritayı güncelleme
    private func updateMap(for index: Int) {
        guard index < flightDataList.count else { return }
        
        let data = flightDataList[index]
        let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        
        // Önceki işaretçileri kaldırıyoruz
        mapView.removeAnnotations(mapView.annotations)
        
        // Yeni işaretçi ekliyoruz
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Konum: \(index + 1)"
        mapView.addAnnotation(annotation)
        
        // Harita bölgesini güncelliyoruz
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Yol çizme
        drawPathOnMap()
    }

    // Harita üzerinde yol çizme (Poligonun kapanmasını sağlamak)
    private func drawPathOnMap() {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for data in flightDataList {
            let coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            coordinates.append(coordinate)
        }
        
        // Poligon oluşturuluyor
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
}

// MKMapViewDelegate metodunu implement et
extension FlightDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

*/


/*
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
*/
