//
//  BillStatus.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 17/12/24.
//

/*
import Foundation
import SwiftUI

struct BillStatus: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
       // ProgressView()
        VStack{
            Title_Status
            ScrollView(.vertical, showsIndicators: false) {
                Status_Progress
                Order_Summary
            }
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            modelData.fetchDrink()
        }
    }
}

struct Title_Status: View {
    
}

struct Status_Progress: View {
    
}

struct Order_Summary: View {
    
}

struct BillStatusView_Previews: PreviewProvider {
    static var previews: some View {
        BillStatus()
            .environmentObject(ModelData())
    }
}

import Foundation
import SwiftUI

struct BillStatusView: View {
    var order: Orders
    @EnvironmentObject var authviewModel: AuthViewModel
    @StateObject private var orderViewModel = OrderViewModel()
    @State private var isCanceled = false // Track if the order is canceled
    @State private var isApproved = false // Track if the order is approved
    @State private var isShipping = false // Track if the order is approved
    
    
    //let orderID: String
    //let receiver: String
    //let dateTime: String
    //let ET: String
    var currentStage: Int = 0 // 0 = Confirmed, 1 = Shipping, 2 = Shipped
    let shipperName: String = "Taylor Swift"
    let vehicle: String = "Ford Transit"
    let plateNumber: String = "XYZ-1234"

    var body: some View {
        NavigationView {
            if let user = authviewModel.currentUser {
                ScrollView{
                    VStack(alignment:.leading, spacing: 5) {
                        // Top Section
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Mã đơn: \(LocalizedStringKey(order.id))")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                            
                            Text("Người nhận: \(user.fullName)")
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                            
                            Text("Thời gian đặt: \(order.timestamp)")
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                            
                            Text("Số điện thoại: \(user.phoneNumber)")
                                .foregroundColor(.gray)
                            
                            //Text("Dự kiến giao: \(ET)")
                               // .foregroundColor(.gray)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        //Divider() // Line between sections
                        //.padding(.horizontal, 16)
                        // Match alignment with text and progress bar
                        // Sharp Line Between Sections
                        Rectangle()
                            .fill(Color.black) // Use a solid black color for a sharper line
                            .frame(height: 1) // Control thickness of the line
                            .padding(.horizontal, 16) // Align with text and progress bar
                        
                        // Progress Bar Section
                        VStack(alignment: .leading, spacing: 5){
                            
                            Text("HAHA đang tới rồi nè!")
                                .padding()
                            HStack {
                                // Stages
                                ForEach(0..<3) { stage in
                                    VStack {
                                        if order.orderstatus {currentStage = 1}
                                        if order.shipping {currentStage = 2}
                                        Circle()
                                            .fill(stage <= currentStage ? Color.color1 : Color.gray)
                                            .frame(width: 20, height: 20)
                                        Text(stageLabel(for: stage))
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    if stage < 2 { // Add line between circles
                                        Rectangle()
                                            .fill(stage < currentStage ? Color.color1 : Color.gray)
                                            .frame(height: 2)
                                            .padding(.horizontal, 5)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                        }
                        /*
                         VStack(alignment: .leading, spacing: 200) {
                         Image("LOGO")
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 400, height: 300)
                         .padding(.top)
                         }
                         */
                        VStack(spacing: 10) {
                            Text("Thông tin Shipper.                                            ")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("Tên: \(shipperName)")
                                .font(.body)
                                .foregroundColor(.black)
                            
                            Text("Phương tiện: \(vehicle)")
                                .font(.body)
                                .foregroundColor(.black)
                            
                            Text("Biển số xe: \(plateNumber)")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.color1)
                        .opacity(0.8)
                        .cornerRadius(8) // Rounded corners for better aesthetics
                        .padding(.horizontal, 10) // Align with the other sections
                        // Navigation Link to LandingPage (Home)
                        NavigationLink(destination: LandingPage()) {
                            Text("Quay về trang chủ")
                                .font(.title2)
                                .foregroundColor(.color2)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding(.top, 20)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
        }
    }
    
        private func stageLabel(for stage: Int) -> String {
            switch stage {
            case 0: return "Xác nhận đơn"
            case 1: return "Đang giao"
            case 2: return "Đã nhận hàng"
            default: return ""
            }
        }
}



    struct BillStatus: View {
        var body: some View {
                BillStatusView(
                    order: order,
                    currentStage: 0)
        }
    }
 
 

struct BillStatusView_Previews: PreviewProvider {
    static var previews: some View {
        BillStatus()
    }
}

import Foundation
import SwiftUI

struct BillStatusView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var orderViewModel = OrderViewModel()
    @State private var order: Orders?
    @State private var showDeleteConfirmation = false
    @State private var navigateToEmptyCart = false

    var body: some View {
        NavigationView {
            if let order = order {
                // Order found and is being displayed
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mã đơn: \(order.id)")
                            .font(.headline)
                            .padding(.bottom)

                        Text("Tổng cộng: \(order.totalPrice) VNĐ")
                            .font(.subheadline)
                            .padding(.bottom)

                        Text("Trạng thái: \(orderStatusText())")
                            .foregroundColor(.blue)
                            .padding(.bottom)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Chi tiết đơn hàng")
                                .font(.headline)

                            ForEach(order.items, id: \.id) { item in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Tên nước: \(item.drinkName)")
                                    Text("Số lượng: \(item.quantity)")
                                    Text("Giá: \(item.totalPrice) VNĐ")
                                }
                                .padding(.bottom, 5)
                            }
                        }

                        Spacer()

                        // Cancel Order Button
                        Button(action: { showDeleteConfirmation = true }) {
                            Text("Hủy đơn hàng")
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .alert("Bạn có chắc chắn muốn hủy đơn hàng này không?", isPresented: $showDeleteConfirmation) {
                            Button("Hủy", role: .cancel) {}
                            Button("Xác nhận", role: .destructive) {
                                cancelOrder()
                            }
                        }

                        // Navigate to Empty Cart if order.shipping == true
                        if order.shipping {
                            NavigationLink(
                                destination: CartView().navigationBarBackButtonHidden(true),
                                isActive: $navigateToEmptyCart
                            ) {
                                Button(action: {
                                    navigateToEmptyCart = true
                                }) {
                                    Text("Xác nhận đã nhận hàng")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Chi tiết đơn hàng")
            } else {
                // Loading or No Order message
                ProgressView("Đang tải...") // Show loading spinner while fetching the order
                    .onAppear {
                        fetchLatestOrder()
                    }
            }
        }
    }

    private func fetchLatestOrder() {
        guard let uid = authViewModel.currentUser?.id else {
            print("Error: User ID not found.")
            return
        }

        orderViewModel.fetchCustomerOrders(forUserID: uid) { fetchedOrders in
            DispatchQueue.main.async {
                if let latestOrder = fetchedOrders.first { // Assuming the latest order is the first in the list
                    self.order = latestOrder
                } else {
                    self.order = nil // Set to nil if no orders are found
                    print("No orders found for the user.")
                }
            }
        }
    }

    private func cancelOrder() {
        guard let orderID = order?.id else { return }
        orderViewModel.updateOrderStatus(orderId: orderID, field: "canceled", value: true) { success in
            if success {
                print("Đơn hàng đã được hủy.")
                order?.canceled = true
            }
        }
    }

    private func orderStatusText() -> String {
        if order?.canceled == true { return "Đã hủy" }
        if order?.shipping == true { return "Đã giao hàng" }
        if order?.orderstatus == true { return "Đang chờ giao hàng" }
        return "Đang chờ xác nhận"
    }
}

*/


import Foundation
import SwiftUI

struct BillStatusView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var orderViewModel = OrderViewModel()
    @State private var orders: [Orders] = [] // Array to hold multiple orders
    @State private var showDeleteConfirmation = false
    @State private var navigateToEmptyCart = false
    let shipperName: String = "Taylor Swift"
    let vehicle: String = "Ford Transit"
    let plateNumber: String = "XYZ-1234"

    var body: some View {
        NavigationView {
            if !orders.isEmpty {
                // Display all orders if fetched
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(orders, id: \.id) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Mã đơn: \(order.id)")
                                    .font(.headline)
                                    .padding(.bottom)
                                
                                Text("Thời gian đặt: \(order.timestamp)")
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)

                                Text("Tổng cộng: \(order.totalPrice) VNĐ")
                                    .font(.subheadline)
                                    .padding(.bottom)

                                Text("Trạng thái: \(orderStatusText(order: order))")
                                    .foregroundColor(.blue)
                                    .padding(.bottom)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Chi tiết đơn hàng")
                                        .font(.headline)

                                    ForEach(order.items, id: \.id) { item in
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Tên nước: \(item.drinkName)")
                                            Text("Cỡ: \(item.size)")
                                            Text("Đá: \(item.ice)")
                                            Text("Đường: \(item.sugar)")
                                            Text("Số lượng: \(item.quantity)")
                                            Text("Giá: \(item.totalPrice) VNĐ")
                                        }
                                        .padding(.bottom, 5)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Thông tin Shipper:")
                                        .font(.headline)
                                    
                                    Text("Tên: \(shipperName)")
                                    Text("Phương tiện: \(vehicle)")
                                    Text("Biển số xe: \(plateNumber)")
                      
                                }
                                

                                Spacer()

                                // Cancel Order Button
                                Button(action: { showDeleteConfirmation = true }) {
                                    Text("Hủy đơn hàng")
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                .alert("Bạn có chắc chắn muốn hủy đơn hàng này không?", isPresented: $showDeleteConfirmation) {
                                    Button("Hủy", role: .cancel) {}
                                    Button("Xác nhận", role: .destructive) {
                                        cancelOrder(order: order)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Danh sách đơn hàng")
            } else {
                // Show loading spinner while fetching orders
                ProgressView("Đang tải...")
                    .onAppear {
                        fetchAllOrders() // Fetch all orders when view appears
                    }
            }
        }
    }

    private func fetchAllOrders() {
        print("Attempting to fetch all orders for the current user.")
        
        // Ensure we have a valid user ID
        guard let uid = authViewModel.currentUser?.id else {
            print("Error: User ID not found. Ensure the user is logged in and authViewModel.currentUser is set.")
            return
        }
        
        print("User ID found: \(uid)")
        
        // Fetch customer orders
        orderViewModel.fetchCustomerOrders(forUserID: uid) { fetchedOrders in
            DispatchQueue.main.async {
                if fetchedOrders.isEmpty {
                    print("No orders found for user ID: \(uid).")
                    self.orders = [] // Clear the current orders list if no orders are fetched
                    return
                }
                
                print("Fetched \(fetchedOrders.count) orders for user ID: \(uid)")
                
                // Optionally log the fetched orders for inspection
                fetchedOrders.forEach { order in
                    print("Order ID: \(order.id), Timestamp: \(order.timestamp)")
                }
                
                // Assign fetched orders to local property
                self.orders = fetchedOrders
            }
        }
    }


    private func cancelOrder(order: Orders) {
        let orderID = order.id
        orderViewModel.updateOrderStatus(orderId: orderID, field: "canceled", value: true) { success in
            if success {
                print("Đơn hàng đã được hủy.")
            }
        }
    }

    private func orderStatusText(order: Orders) -> String {
        if order.canceled == true { return "Đã hủy" }
        if order.shipping == true { return "Đã giao hàng" }
        if order.orderstatus == true { return "Đang chờ giao hàng" }
        return "Đang chờ xác nhận"
    }
}
 
 
 
/*
import SwiftUI

struct BillStatusView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var orderViewModel = OrderViewModel()
    @State private var orders: [Orders] = [] // Array to hold multiple orders
    @State private var showDeleteConfirmation = false
    @State private var navigateToEmptyCart = false

    var body: some View {
        NavigationView {
            if !orders.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(orders, id: \.id) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Mã đơn: \(order.id)")
                                    .font(.headline)
                                    .padding(.bottom)
                                
                                Text("Tên người nhận: \(order.id)")
                                    .font(.headline)
                                    .padding(.bottom)
                                
                                Text("Thời gian đặt: \(order.timestamp)")
                                    .font(.headline)
                                    .padding(.bottom)

                                Text("Tổng cộng: \(order.totalPrice) VNĐ")
                                    .font(.subheadline)
                                    .padding(.bottom)
                                
                                Text("Trạng thái:")
                                    .foregroundColor(.blue)
                                    .padding(.bottom)

                                VStack(spacing: 10) {
                                    // Sequence diagram for order status
                                    ForEach(OrderStatus.allCases, id: \.self) { status in
                                        Circle()
                                            .fill(status.color(for: order))
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                Text(status.shortName)
                                                    .font(.caption2)
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                                .padding(.vertical)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Chi tiết đơn hàng")
                                        .font(.headline)

                                    ForEach(order.items, id: \.id) { item in
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Tên nước: \(item.drinkName)")
                                            Text("Cỡ: \(item.size)")
                                            Text("Đá: \(item.ice)")
                                            Text("Đường: \(item.sugar)")
                                            Text("Số lượng: \(item.quantity)")
                                            Text("Giá: \(item.totalPrice) VNĐ")
                                        }
                                        .padding(.bottom, 5)
                                    }
                                }

                                Spacer()

                                // Cancel Order Button
                                Button(action: { showDeleteConfirmation = true }) {
                                    Text("Hủy đơn hàng")
                                        .foregroundColor(.red)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                .alert("Bạn có chắc chắn muốn hủy đơn hàng này không?", isPresented: $showDeleteConfirmation) {
                                    Button("Hủy", role: .cancel) {}
                                    Button("Xác nhận", role: .destructive) {
                                        cancelOrder(order: order)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Danh sách đơn hàng")
            } else {
                ProgressView("Đang tải...")
                    .onAppear {
                        fetchAllOrders()
                    }
            }
        }
    }

    private func fetchAllOrders() {
        print("Attempting to fetch all orders for the current user.")
        
        // Ensure we have a valid user ID
        guard let uid = authViewModel.currentUser?.id else {
            print("Error: User ID not found. Ensure the user is logged in and authViewModel.currentUser is set.")
            return
        }
        
        print("User ID found: \(uid)")
        
        // Fetch customer orders
        orderViewModel.fetchCustomerOrders(forUserID: uid) { fetchedOrders in
            DispatchQueue.main.async {
                if fetchedOrders.isEmpty {
                    print("No orders found for user ID: \(uid).")
                    self.orders = [] // Clear the current orders list if no orders are fetched
                    return
                }
                
                print("Fetched \(fetchedOrders.count) orders for user ID: \(uid)")
                
                // Optionally log the fetched orders for inspection
                fetchedOrders.forEach { order in
                    print("Order ID: \(order.id), Timestamp: \(order.timestamp)")
                }
                
                // Assign fetched orders to local property
                self.orders = fetchedOrders
            }
        }
    }


    private func cancelOrder(order: Orders) {
        let orderID = order.id
        orderViewModel.updateOrderStatus(orderId: orderID, field: "canceled", value: true) { success in
            if success {
                print("Đơn hàng đã được hủy.")
            }
        }
    }

}

// Helper struct to define statuses
enum OrderStatus: CaseIterable {
    case pending
    case shipping
    case delivered
    case canceled

    func color(for order: Orders) -> Color {
        switch self {
        case .pending:
            return order.orderstatus == true ? .blue : .gray
        case .shipping:
            return order.shipping == true ? .green : .gray
        case .delivered:
            return order.shipping == true ? .purple : .gray
        case .canceled:
            return order.canceled == true ? .red : .gray
        }
    }

    var shortName: String {
        switch self {
        case .pending: return "ĐC"
        case .shipping: return "GH"
        case .delivered: return "DG"
        case .canceled: return "H"
        }
    }
}

*/
