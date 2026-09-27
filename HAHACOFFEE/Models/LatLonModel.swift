//
//  LatLonModel.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

import Foundation
import FirebaseFirestore
import Firebase

struct LatnLon_Store: Codable, Identifiable, Equatable{
    var Lat: Double
    var Lon: Double
    var address: String
    var id: String
}

struct LatnLon_User: Codable, Identifiable,Equatable {
    var id: String { orderId }
    var customerName: String
    var latitude: Double
    var longitude: Double
    var orderId: String
    var timestamp: Date
}

class LatnLon: ObservableObject {
    @Published var lat_lon_store: [LatnLon_Store] = []
    @Published var lat_lon_user: [LatnLon_User] = []

    init() {
        fetchLatLonStore()
        fetchLatLonUser()
    }

    func fetchLatLonStore() {
        let db = Firestore.firestore()
        let ref = db.collection("Test Lat Lon")

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching LatLon_Store: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found in Test Lat Lon.")
                return
            }

            DispatchQueue.main.async {
                self.lat_lon_store = documents.compactMap { document in
                    let data = document.data()
                    if let Lat = data["Lat"] as? Double,
                       let Lon = data["Lon"] as? Double,
                       let address = data["address"] as? String {
                        return LatnLon_Store(Lat: Lat, Lon: Lon, address: address, id: document.documentID)
                    } else {
                        print("Error parsing LatLon_Store document: \(document.documentID)")
                        return nil
                    }
                }
            }
        }
    }

    func fetchLatLonUser() {
        let db = Firestore.firestore()
        let ref = db.collection("LatLon")

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching LatLon_User: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found in LatLon.")
                return
            }

            DispatchQueue.main.async {
                self.lat_lon_user = documents.compactMap { document in
                    let data = document.data()
                    if let customerName = data["customerName"] as? String,
                       let latitude = data["latitude"] as? Double,
                       let longitude = data["longitude"] as? Double,
                       let orderId = data["orderId"] as? String,
                       let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() {
                        return LatnLon_User(customerName: customerName, latitude: latitude, longitude: longitude, orderId: orderId, timestamp: timestamp)
                    } else {
                        print("Error parsing LatLon_User document: \(document.documentID)")
                        return nil
                    }
                }
            }
        }
    }
}

