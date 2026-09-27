//
//  Staff.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 21/12/24.
//

// OrderView.swift
import SwiftUI
import FirebaseAuth
import MapKit
import FirebaseFirestore

struct StaffView: View {
    @StateObject private var orderViewModel = OrderViewModel() // For order-related logic
    @EnvironmentObject var viewModel: AuthViewModel // For authentication and user session management
    @State private var userRole: String = "" // To store the role of the user
    @State private var isLoading = true // To manage loading state
    @Environment(\.dismiss) private var dismiss // To dismiss the current view

    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading...")
                    .onAppear {
                        fetchUserRole()
                    }
            } else {
                VStack {
                    // Filter options in the navigation bar
                    Picker("Status", selection: $orderViewModel.selectedFilter) {
                        if userRole == "staff" {
                            Text("Pending").tag("Pending")
                        }
                        Text("Delivering").tag("Delivering")
                        Text("Completed").tag("Completed")
                        Text("Canceled").tag("Canceled")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: orderViewModel.selectedFilter) { _ in
                        orderViewModel.applyFilter()
                    }

                    // Show the appropriate list based on selectedFilter and role
                    List(orderViewModel.filteredOrders) { order in
                        if userRole == "staff" && orderViewModel.selectedFilter == "Pending" {
                            OrderRow_Approval(order: order, viewModel: orderViewModel)
                        } else if orderViewModel.selectedFilter == "Delivering" {
                            OrderRow_Delivery(order: order, viewModel: orderViewModel)
                        } else if orderViewModel.selectedFilter == "Completed" {
                            OrderRow_Completed(order: order, viewModel: orderViewModel)
                        } else if orderViewModel.selectedFilter == "Canceled" {
                            OrderRow_Canceled(order: order, viewModel: orderViewModel)
                        }
                    }

                    Spacer()

                    // Log Out Button
                    Button(action: {
                        viewModel.logOut()
                        dismiss()
                    }) {
                        Text("Log out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationTitle("Order Status")
            }
        }
    }

    // Fetch the user's role from Firestore
    private func fetchUserRole() {
        guard let uid = viewModel.userSession?.uid else {
            isLoading = false
            return
        }

        let docRef = Firestore.firestore().collection("User").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user role: \(error.localizedDescription)")
                isLoading = false
                return
            }

            if let data = snapshot?.data(), let role = data["role"] as? String {
                self.userRole = role
            }

            isLoading = false
        }
    }
}


// Single Order Row View
struct OrderRow_Delivery: View {
    let order: Orders
    @ObservedObject var viewModel: OrderViewModel
    @State private var userRole: String = ""
    @EnvironmentObject var authviewModel: AuthViewModel
    @State private var isUpdating = false
    @State private var isCanceled = false // Track if the order is canceled
    @State private var actionMessage: String? // Message to display after action
    @State private var isLoading = true // To manage loading state
    @State private var isApproved = false // Track if the order is approved

    var body: some View {
        if isLoading {
            ProgressView("Đang tải...")
                .onAppear {
                    fetchUserRole()
                }
        } else {
            VStack(alignment: .leading) {
                Text("Mã đơn: \(order.id)")
                    .font(.headline)
                ForEach(order.items, id: \.id) { item in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Thời gian đặt: \(order.timestamp)")
                        Text("Tên nước: \(item.drinkName)")
                            .font(.subheadline)
                            .bold()
                        Text("Kích cỡ: \(item.size)")
                        Text("Lượng đá: \(item.ice)")
                        Text("Lượng đường: \(item.sugar)")
                        Text("Số lượng: \(item.quantity)")
                        Text("Giá: \(item.totalPrice) VNĐ")
                    }
                    .padding(.vertical, 5)
                    .cornerRadius(8)
                }
                Text("Tổng cộng: \(order.totalPrice) VNĐ")
                    .font(.subheadline)
                    .bold()
                
                if userRole == "shipper" {
                    
                    HStack{
                        
                        // Approve Button
                        Button(action: {
                            isUpdating = true
                            viewModel.updateOrderStatus(orderId: order.id, field: "shipping", value: true) { success in
                                isUpdating = false
                                if success {
                                    isApproved = true
                                    actionMessage = "Đã giao"
                                    withAnimation {
                                        viewModel.removeFromFilteredOrders(orderId: order.id) // Remove from UI
                                    }
                                } else {
                                    actionMessage = "Failed to ship order"
                                }
                            }
                        }) {
                            Text("Đã giao")
                                .padding()
                                .background(isApproved ? Color.green : Color.blue) // Change color when approved
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(isUpdating)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        
                        
                        // View Button (Eye Icon)
                        NavigationLink(destination: RouteMapView(
                            //,userLocation: CLLocationCoordinate2D(latitude: 10.762622, longitude: 106.660172)
                        ).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "eye")
                            .foregroundColor(.blue)
                            .padding()
                            .frame(width: 44, height: 44)
                            }
                        .buttonStyle(BorderlessButtonStyle())
                        

                        Spacer()
                        
                        
                        // Cancel Button
                        Button(action: {
                            isUpdating = true
                            viewModel.updateOrderStatus(orderId: order.id, field: "canceled", value: true) { success in
                                isUpdating = false
                                if success {
                                    isCanceled = true
                                    actionMessage = "Order canceled"
                                    withAnimation {
                                        viewModel.removeFromFilteredOrders(orderId: order.id) // Remove from UI
                                    }
                                } else {
                                    actionMessage = "Failed to cancel order"
                                }
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .padding()
                                .frame(width: 44, height: 44)
                        }
                        .disabled(isUpdating)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                
                
            }
            .padding()
        }
    }
    // Fetch the user's role from Firestore
    private func fetchUserRole() {
        guard let uid = authviewModel.userSession?.uid else {
            isLoading = false
            return
        }
        let docRef = Firestore.firestore().collection("User").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user role: \(error.localizedDescription)")
                isLoading = false
                return
            }

            if let data = snapshot?.data(), let role = data["role"] as? String {
                self.userRole = role
            }

            isLoading = false
        }
    }
}


// Single Order Row View
struct OrderRow_Completed: View {
    let order: Orders
    @ObservedObject var viewModel: OrderViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mã đơn: \(order.id)")
                .font(.headline)
            ForEach(order.items, id: \.id) { item in
                           VStack(alignment: .leading, spacing: 5) {
                               Text("Thời gian đặt: \(order.timestamp)")
                               Text("Tên nước: \(item.drinkName)")
                                   .font(.subheadline)
                                   .bold()
                               Text("Kích cỡ: \(item.size)")
                               Text("Lượng đá: \(item.ice)")
                               Text("Lượng đường: \(item.sugar)")
                               Text("Số lượng: \(item.quantity)")
                               Text("Giá: \(item.totalPrice) VNĐ")
                           }
                           .padding(.vertical, 5)
                           .cornerRadius(8)
                       }
            Text("Tổng cộng: \(order.totalPrice) VNĐ")
                .font(.subheadline)
                .bold()
        }
        .padding()
    }

}

// Single Order Row View
struct OrderRow_Canceled: View {
    let order: Orders
    @ObservedObject var viewModel: OrderViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mã đơn: \(order.id)")
                .font(.headline)
            ForEach(order.items, id: \.id) { item in
                           VStack(alignment: .leading, spacing: 5) {
                               Text("Thời gian đặt: \(order.timestamp)")
                               Text("Tên nước: \(item.drinkName)")
                                   .font(.subheadline)
                                   .bold()
                               Text("Kích cỡ: \(item.size)")
                               Text("Lượng đá: \(item.ice)")
                               Text("Lượng đường: \(item.sugar)")
                               Text("Số lượng: \(item.quantity)")
                               Text("Giá: \(item.totalPrice) VNĐ")
                           }
                           .padding(.vertical, 5)
                           .cornerRadius(8)
                       }
            Text("Tổng cộng: \(order.totalPrice) VNĐ")
                .font(.subheadline)
                .bold()
        }
        .padding()
    }

}

struct OrderRow_Approval: View {
    let order: Orders
    @ObservedObject var viewModel: OrderViewModel
    @State private var isUpdating = false
    @State private var actionMessage: String? // Message to display after action
    @State private var isApproved = false // Track if the order is approved
    @State private var isCanceled = false // Track if the order is canceled

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Order Details
            Text("Mã đơn: \(order.id)")
                .font(.headline)

            ForEach(order.items, id: \.id) { item in
                VStack(alignment: .leading, spacing: 5) {
                    Text("Thời gian đặt: \(order.timestamp)")
                    Text("Tên nước: \(item.drinkName)")
                        .font(.subheadline)
                        .bold()
                    Text("Kích cỡ: \(item.size)")
                    Text("Lượng đá: \(item.ice)")
                    Text("Lượng đường: \(item.sugar)")
                    Text("Số lượng: \(item.quantity)")
                    Text("Giá: \(item.totalPrice) VNĐ")
                }
                .padding(.vertical, 5)
            }

            Text("Tổng cộng: \(order.totalPrice) VNĐ")
                .font(.subheadline)
                .bold()
            Text("Trạng thái: \(viewModel.updatedStatus(for: order))")
                .foregroundColor(orderStatusColor(viewModel.updatedStatus(for: order)))

            HStack {
                // Approve Button
                Button(action: {
                    isUpdating = true
                    viewModel.updateOrderStatus(orderId: order.id, field: "orderstatus", value: true) { success in
                        isUpdating = false
                        if success {
                            isApproved = true
                            actionMessage = "Order approved"
                            withAnimation {
                                viewModel.removeFromFilteredOrders(orderId: order.id) // Remove from UI
                            }
                        } else {
                            actionMessage = "Failed to approve order"
                        }
                    }
                }) {
                    Text("Xác nhận")
                        .padding()
                        .background(isApproved ? Color.green : Color.blue) // Change color when approved
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isUpdating)
                .buttonStyle(BorderlessButtonStyle())

                Spacer()

                // Cancel Button
                Button(action: {
                    isUpdating = true
                    viewModel.updateOrderStatus(orderId: order.id, field: "canceled", value: true) { success in
                        isUpdating = false
                        if success {
                            isCanceled = true
                            actionMessage = "Order canceled"
                            withAnimation {
                                viewModel.removeFromFilteredOrders(orderId: order.id) // Remove from UI
                            }
                        } else {
                            actionMessage = "Failed to cancel order"
                        }
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                        .frame(width: 44, height: 44)
                }
                .disabled(isUpdating)
                .buttonStyle(BorderlessButtonStyle())
            }

            // Action Message
            if let message = actionMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(isApproved ? .green : (isCanceled ? .red : .orange))
                    .padding(.top, 8)
            }
        }
        .contentShape(Rectangle())
        .padding()
    }

    private func orderStatusColor(_ status: String) -> Color {
        switch status {
        case "Pending":
            return .orange
        case "Delivering":
            return .blue
        case "Completed":
            return .green
        case "Canceled":
            return .red
        default:
            return .gray
        }
    }
}
