//
//  OrderViewModel.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 22/12/24.
//
import Foundation
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    @Published var orders: [Orders] = []
    @Published var filteredOrders: [Orders] = []
    @Published var selectedFilter: String = "Pending" // Default filter
    @Published var errorMessage: String? = nil // For error feedback
    @Published var canceledOrders: [Orders] = [] // Holds orders marked as canceled

    private let db = Firestore.firestore()

    init() {
        fetchOrders()
    }

    // Fetch orders from Firebase
    func fetchOrders() {
        db.collection("Orders").order(by: "timestamp", descending: true).getDocuments { [weak self] (snapshot, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error fetching orders: \(error.localizedDescription)"
                    print("Error fetching orders: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                self?.orders = documents.compactMap { doc in
                    Orders(documentId: doc.documentID, dictionary: doc.data())
                }
                print("Fetched \(self?.orders.count ?? 0) orders.")
                self?.applyFilter()
            }
        }
    }
    
    func fetchCustomerOrders(forUserID userID: String, completion: @escaping ([Orders]) -> Void) {
        print("Attempting to fetch orders for userID: \(userID)")
        
        db.collection("Orders")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching orders: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found for userID: \(userID)")
                    completion([])
                    return
                }
                
                let fetchedOrders = documents.compactMap { doc -> Orders? in
                    let data = doc.data()
                    print("Document ID: \(doc.documentID), Data: \(data)")
                    return Orders(documentId: doc.documentID, dictionary: data)
                }
                
                // Sort orders by timestamp in descending order
                let sortedOrders = fetchedOrders.sorted { $0.timestamp > $1.timestamp }
                
                DispatchQueue.main.async {
                    print("Fetched and sorted \(sortedOrders.count) orders for userID: \(userID)")
                    completion(sortedOrders)
                }
            }
    }

    

    // Remove an order from the filtered list
    func removeFromFilteredOrders(orderId: String) {
        filteredOrders.removeAll { $0.id == orderId }
    }

    // Determine the updated status as a text string
    func updatedStatus(for order: Orders) -> String {
        if !order.orderstatus && !order.canceled {
            return "Pending"
        } else if order.orderstatus && !order.shipping && !order.canceled {
            return "Delivering"
        } else if order.shipping && order.payment && !order.canceled {
            return "Completed"
        } else if order.canceled {
            return "Canceled"
        } else {
            return "Unknown"
        }
    }

    // Apply filter based on selectedFilter
    func applyFilter() {
        print("Applying filter: \(selectedFilter)")
        switch selectedFilter {
        case "Pending":
            filteredOrders = orders.filter { !$0.orderstatus && !$0.shipping && !$0.canceled}
        case "Delivering":
            filteredOrders = orders.filter { $0.orderstatus && !$0.shipping && !$0.canceled}
        case "Completed":
            filteredOrders = orders.filter { $0.orderstatus && $0.shipping}
        case "Canceled":
            filteredOrders = orders.filter { $0.canceled }
        default:
            filteredOrders = orders
        }
        sortFilteredOrders()
        print("Filtered orders count: \(filteredOrders.count)")
    }

    // Sort filtered orders by timestamp (most recent first)
    private func sortFilteredOrders() {
        filteredOrders.sort { $0.timestamp > $1.timestamp }
    }

    // Add an order to the canceled list
    func addToCanceled(order: Orders) {
        canceledOrders.append(order)
        canceledOrders.sort { $0.timestamp > $1.timestamp }
        print("Order \(order.id) added to Canceled list.")
    }

    // Update specific field in an order
    func updateOrderStatus(orderId: String, field: String, value: Bool, completion: @escaping (Bool) -> Void) {
        print("Attempting to update \(field) for order \(orderId) with value: \(value)")
        let orderRef = db.collection("Orders").document(orderId)
        
        // Create the update data dictionary
         let updateData: [String: Any] = [
             field: value,
             "timestamp": FieldValue.serverTimestamp() // Optional: Update timestamp
         ]

        orderRef.updateData([field: value]) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating order \(orderId): \(error.localizedDescription)")
                    self?.errorMessage = "Error updating order: \(error.localizedDescription)"
                    completion(false)
                    return
                }

                print("Successfully updated \(field) for order \(orderId) to \(value)")

                
                // Refetch orders to reflect updated data from Firestore
                self?.fetchOrders()
                
                completion(true)
            }
        }
    }
}
