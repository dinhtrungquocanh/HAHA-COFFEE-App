//
//  Orders.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 17/12/24.
//
// Orders.swift
import Foundation
import FirebaseFirestore

struct Orders: Identifiable {
    var id: String
    var userID: String // Add this field
    var timestamp: Date
    var totalPrice: Int
    var orderstatus: Bool // "Canceled", "Shipped", or "Pending"
    var shipping: Bool
    var payment: Bool
    var canceled: Bool
    var items: [CartItem]

    init(documentId: String, dictionary: [String: Any]) {
        self.id = documentId
        self.userID = dictionary["userID"] as? String ?? ""
        self.timestamp = (dictionary["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.totalPrice = dictionary["totalPrice"] as? Int ?? 0
        self.orderstatus = dictionary["orderstatus"] as? Bool ?? false
        self.shipping = dictionary["shipping"] as? Bool ?? false
        self.payment = dictionary["payment"] as? Bool ?? false
        self.canceled = dictionary["canceled"] as? Bool ?? false
        self.items = (dictionary["items"] as? [[String: Any]])?.compactMap { CartItem(from: $0) } ?? []
    }
}

extension CartItem {
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let drinkId = dictionary["drinkId"] as? String,
              let drinkName = dictionary["drinkName"] as? String,
              let drinkName_en = dictionary["drinkName_en"] as? String,
              let size = dictionary["size"] as? String,
              let ice = dictionary["ice"] as? String,
              let sugar = dictionary["sugar"] as? String,
              let quantity = dictionary["quantity"] as? Int,
              let totalPrice = dictionary["totalPrice"] as? Int else { return nil }

        self.id = id
        self.drinkId = drinkId
        self.drinkName = drinkName
        self.drinkName_en = drinkName_en
        self.size = size
        self.ice = ice
        self.sugar = sugar
        self.quantity = quantity
        self.totalPrice = totalPrice
    }
}

