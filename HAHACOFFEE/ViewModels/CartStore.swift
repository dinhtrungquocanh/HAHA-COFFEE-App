//
//  CartStore.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 17/12/24.
//

import SwiftUI
import Combine
import FirebaseFirestore

class CartStore: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var totalPrice: Int = 0
    @Published var navigateToCart: Bool = false
    
    var numberOfItems: Int {
        cartItems.count
    }
    
    func removeCartItem(_ cartItemId: String) {
        // Find and remove the item by its ID
        if let index = cartItems.firstIndex(where: { $0.id == cartItemId }) {
            print("Removing item: \(cartItems[index].drinkName)")
            cartItems.remove(at: index)
            recalculateTotalPrice()
        } else {
            print("Item with ID \(cartItemId) not found in the cart!")
        }
    }

    // Add a new cart item
    func addCartItem(_ newItem: CartItem) {
        if let existingIndex = cartItems.firstIndex(where: { $0.drinkId == newItem.drinkId && $0.size == newItem.size && $0.ice == newItem.ice && $0.sugar == newItem.sugar }) {
            cartItems[existingIndex].quantity += newItem.quantity
            cartItems[existingIndex].totalPrice += newItem.totalPrice
        } else {
            cartItems.append(newItem)
        }
        recalculateTotalPrice()
        navigateToCart = true // Trigger navigation to cart
    }

    // Clear the cart (called explicitly by the user)
    func clearCart() {
        cartItems.removeAll()
        totalPrice = 0
    }
    
    /*
    func saveOrder() {
        print("Order Saved!")
        for item in cartItems {
            print("Item: \(item.drinkName), Quantity: \(item.quantity), Total: \(item.totalPrice)")
        }
    }
     */
    func saveOrder(for user: User) {
        let db = Firestore.firestore() // Get a Firestore instance
        
        // Prepare the items array as an array of maps
        let itemsArray: [[String: Any]] = cartItems.map { item in
            return [
                "id": item.id,
                "drinkId": item.drinkId,
                "drinkName": item.drinkName,
                "drinkName_en": item.drinkName_en,
                "size": item.size,
                "ice": item.ice,
                "sugar": item.sugar,
                "quantity": item.quantity,
                "totalPrice": item.totalPrice
            ]
        }
        
        // Prepare order data
        let orderData: [String: Any] = [
            "orderId": UUID().uuidString, // Unique order ID
            "userID": user.id,
            "timestamp": Timestamp(date: Date()), // Current time
            "totalPrice": totalPrice,
            "orderstatus": false,
            "shipping": false,
            "payment": false,
            "canceled": false,
            "items": itemsArray
            ]

        // Save order to Firestore
        db.collection("Orders").addDocument(data: orderData) { error in
            if let error = error {
                print("Error saving order: \(error.localizedDescription)")
            } else {
                print("Order successfully saved for user: \(user.fullName)!")
                // Clear the cart after saving
                self.updateOrderStatus()
                self.clearCart()
            }
        }
        
    }


   
    // Helper to update the order status after saving
    func updateOrderStatus() {
        let db = Firestore.firestore()
        db.collection("orders")
            .whereField("orderstatus", isEqualTo: false)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching orders for status update: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                for document in documents {
                    db.collection("orders").document(document.documentID).updateData([
                        "orderstatus": true
                    ]) { error in
                        if let error = error {
                            print("Error updating order status: \(error.localizedDescription)")
                        } else {
                            print("Order status updated successfully!")
                        }
                    }
                }
            }
    }
    
    
    // Recalculate total price
    private func recalculateTotalPrice() {
        totalPrice = cartItems.reduce(0) { $0 + $1.totalPrice }
    }
}
// Define the CartItem model
struct CartItem: Identifiable {
    let id: String
    let drinkId: String
    let drinkName: String
    let drinkName_en: String
    let size: String
    let ice: String
    let sugar: String
    var quantity: Int
    var totalPrice: Int
}

