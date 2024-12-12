//
//  Flight.swift
//  loginAuth2
//
//  Created by Mürşide Gökçe on 12.12.2024.
//

import Foundation
import FirebaseFirestore

// Uçuş modelini temsil eden sınıf
class Flight {
    var flightId: String
    var altitudeM: Int
    var distanceM: Int
    var durationS: Int
    var flightStartTime: Timestamp
    
    // Flight sınıfının initializer fonksiyonu
    init(flightId: String, altitudeM: Int, distanceM: Int, durationS: Int, flightStartTime: Timestamp) {
        self.flightId = flightId
        self.altitudeM = altitudeM
        self.distanceM = distanceM
        self.durationS = durationS
        self.flightStartTime = flightStartTime
    }
}
