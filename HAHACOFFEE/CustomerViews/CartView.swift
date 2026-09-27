//
//  CartView.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 16/12/24.
//
/*
 import Foundation
 import SwiftUI
 
 struct CartView: View {
 @ObservedObject var locationManager = LocationManager()
 @EnvironmentObject var viewModel: AuthViewModel
 @EnvironmentObject var cartManager: CartStore
 @State private var showDeleteConfirmation: Bool = false
 @State private var drinkToDelete: CartItem? = nil
 @ObservedObject var latnLonModel = LatnLon() // Observe LatnLon for dynamic data
 @State private var nearestStoreAddress: String = "Đang xác định vị trí..."
 
 @State private var deliveryType = "Pickup"
 @State private var selectedPickupAddress = "234 Nguyễn Văn Lượng, Gò Vấp"
 @State private var guestName = "Trần An"
 @State private var guestAddress = "616/65 Lê Đức Thọ, phường 15, quận Gò Vấp, thành phố HCM"
 @State private var guestPhoneNumber = "0886768841"
 @State private var selectedPayment = "COD"
 
 @State private var navigateTo: String? = nil // For role-based navigation
 @State private var navigateToBillStatus: Bool = false
 
 let paymentMethods = [
 ("COD", "COD"),
 ("MOMO", "MOMO"),
 ("ZaloPay", "Zalopay"),
 ("PayPal", "PayPal")
 ]
 
 let pickupAddresses = [
 "234 Nguyễn Văn Lượng, Gò Vấp",
 "45 Quang Trung, Gò Vấp"
 ]
 
 @State private var showPayPalButton: Bool = false
 
 var body: some View {
 NavigationView {
 VStack {
 if cartManager.cartItems.isEmpty {
 VStack {
 Text("Giỏ hàng của bạn trống!")
 .font(.headline)
 .padding()
 NavigationLink(destination: LandingPage().navigationBarBackButtonHidden(true)) {
 Text("Order ngay!")
 .font(.subheadline)
 .foregroundColor(.blue)
 }
 }
 .navigationTitle("Giỏ hàng của bạn trống")
 .navigationBarTitleDisplayMode(.inline)
 } else {
 ScrollView {
 VStack(spacing: 10) {
 // Delivery Method Section
 VStack(alignment: .leading, spacing: 10) {
 Text("Hình thức nhận hàng:")
 .font(.headline)
 
 Picker("Hình thức nhận hàng", selection: $deliveryType) {
 Text("Ghé lấy").tag("Pickup")
 Text("Giao hàng").tag("Deliver")
 }
 .pickerStyle(SegmentedPickerStyle())
 }
 .padding()
 .background(Color.white)
 .cornerRadius(10)
 .padding([.horizontal, .top])
 
 // Customer Confirmation Section
 VStack(alignment: .leading, spacing: 10) {
 Text("Thông tin khách hàng:")
 .font(.headline)
 
 HStack {
 Text("Tên khách hàng:")
 Spacer()
 Text(guestName)
 .foregroundColor(.gray)
 }
 
 if deliveryType == "Pickup" {
 VStack(alignment: .leading, spacing: 5) {
 Text("Chọn địa chỉ lấy hàng:")
 Picker("Chọn địa chỉ", selection: $selectedPickupAddress) {
 if nearestStoreAddress != "Đang xác định vị trí..." {
 Text("Gần nhất: \(nearestStoreAddress)").tag(nearestStoreAddress)
 }
 
 if latnLonModel.lat_lon_store.isEmpty {
 Text("Đang tải địa chỉ...").tag("")
 } else {
 ForEach(latnLonModel.lat_lon_store, id: \.id) { store in
 Text(store.address).tag(store.address)
 }
 }
 }
 .pickerStyle(MenuPickerStyle())
 }
 } else {
 HStack {
 Text("Địa chỉ giao hàng:")
 Spacer()
 TextField("Nhập địa chỉ", text: $guestAddress)
 .textFieldStyle(RoundedBorderTextFieldStyle())
 }
 }
 
 HStack {
 Text("Số điện thoại:")
 Spacer()
 Text(guestPhoneNumber)
 .foregroundColor(.gray)
 }
 }
 .padding()
 .background(Color.white)
 .cornerRadius(10)
 .padding(.horizontal)
 
 // Order Review Section
 VStack(alignment: .leading, spacing: 10) {
 Text("Đơn hàng của bạn")
 .font(.headline)
 
 List {
 ForEach(cartManager.cartItems) { item in
 CartItemRow(item: item)
 .swipeActions(edge: .trailing) {
 Button(role: .destructive) {
 drinkToDelete = item
 showDeleteConfirmation = true
 } label: {
 Label("Xóa", systemImage: "trash")
 }
 }
 }
 }
 .listStyle(PlainListStyle())
 .frame(height: 200)
 }
 .padding()
 .background(Color.white)
 .cornerRadius(10)
 .padding(.horizontal)
 
 // Payment Method Section
 VStack(alignment: .leading, spacing: 10) {
 Text("Phương thức thanh toán:")
 .font(.headline)
 
 ForEach(paymentMethods, id: \.0) { method in
 HStack {
 Image(method.1)
 .resizable()
 .scaledToFit()
 .frame(width: 30, height: 30)
 .padding(.trailing, 10)
 
 Text(method.0)
 Spacer()
 Image(systemName: selectedPayment == method.0 ? "checkmark.circle.fill" : "circle")
 .foregroundColor(selectedPayment == method.0 ? .blue : .gray)
 .onTapGesture {
 selectedPayment = method.0
 
 // Open Safari for PayPal
 if method.0 == "PayPal" {
 openPayPalInSafari()
 }
 }
 .padding(.vertical, 5)
 }
 }
 .padding()
 .background(Color.white)
 .cornerRadius(10)
 .padding(.horizontal)
 
 // Total Price and Place Order Button
 VStack(spacing: 15) {
 HStack {
 Text("Tổng cộng:")
 .font(.title2)
 .fontWeight(.bold)
 Spacer()
 Text("\(cartManager.totalPrice) VNĐ")
 .font(.title2)
 .fontWeight(.bold)
 .foregroundColor(.blue)
 }
 
 
 Button(action: {
 if viewModel.userSession == nil {
 navigateTo = "login-cart" // Cart button login
 } else {
 //let currentUser = viewModel.currentUser
 //navigateTo = "cart"
 //placeOrder(for: currentUser) // Proceed with the order
 cartManager.saveOrder(for: viewModel.currentUser)
 navigateToBillStatus = true
 }
 }) {
 Text("Đặt hàng")
 .foregroundColor(.white)
 .frame(maxWidth: .infinity)
 .padding()
 .background(Color.blue)
 .cornerRadius(10)
 }
 
 // Navigation Links
 NavigationLink(
 destination: LoginView(source: navigateTo == "login-cart" ? "cart" : nil),
 tag: "login-cart",
 selection: $navigateTo
 ) { EmptyView() }
 
 NavigationLink(destination: CartView(), tag: "cart", selection: $navigateTo) { EmptyView() }
 
 NavigationLink(
 destination: BillStatusView(),
 isActive: $navigateToBillStatus
 ) { EmptyView() }
 }
 .padding(.horizontal)
 }
 }
 .navigationTitle("Giỏ hàng")
 .navigationBarTitleDisplayMode(.inline)
 .alert("Bạn có chắc muốn xóa sản phẩm này không?", isPresented: $showDeleteConfirmation) {
 Button("Hủy", role: .cancel) {}
 Button("Xóa", role: .destructive) {
 if let drink = drinkToDelete {
 cartManager.removeCartItem(drink.id)
 }
 }
 } message: {
 Text(drinkToDelete?.drinkName ?? "Sản phẩm")
 }
 }
 }
 } .navigationBarBackButtonHidden(true) // Show/hide back button dynamically
 }
 }
 
 private func placeOrder() {
 guard !cartManager.cartItems.isEmpty else {
 print("Giỏ hàng trống.")
 return
 }
 print("Đơn hàng đã đặt thành công!")
 }
 
 private func updateNearestStore() {
 guard let userLocation = locationManager.userLocation else {
 print("User location not available yet.")
 return
 }
 if let nearestStore = latnLonModel.calculateNearestStore(userLocation: userLocation) {
 nearestStoreAddress = nearestStore.address
 } else {
 nearestStoreAddress = "Không tìm thấy cửa hàng gần."
 }
 }
 
 private func openPayPalInSafari() {
 let filePath = "http://localhost:8000/index.html"
 guard let url = URL(string: filePath) else {
 print("Invalid URL format: \(filePath)")
 return
 }
 
 print("Attempting to open URL: \(url)")
 UIApplication.shared.open(url, options: [:]) { success in
 if success {
 print("PayPal page opened successfully.")
 } else {
 print("Failed to open PayPal page.")
 }
 }
 }
 }
 
 struct CartItemRow: View {
 let item: CartItem
 
 var body: some View {
 HStack {
 VStack(alignment: .leading) {
 Text(item.drinkName)
 .font(.headline)
 
 Text("Kích cỡ: \(item.size) | Đá: \(item.ice) | Đường: \(item.sugar)")
 .font(.subheadline)
 .foregroundColor(.gray)
 
 Text("Số lượng: \(item.quantity)")
 .font(.subheadline)
 }
 
 Spacer()
 
 Text("\(item.totalPrice) VNĐ")
 .font(.headline)
 .foregroundColor(.blue)
 }
 .padding(.vertical, 5)
 }
 }
 
 
 struct CartView_Previews: PreviewProvider {
 static var previews: some View {
 CartView()
 .environmentObject(CartStore())
 }
 }
 
 */
import Foundation
import SwiftUI
import Firebase

struct CartView: View {
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var cartManager: CartStore
    @State private var showDeleteConfirmation: Bool = false
    @State private var drinkToDelete: CartItem? = nil
    @ObservedObject var latnLonModel = LatnLon()
    @State private var nearestStoreAddress: String = "Đang xác định vị trí..."
    
    @State private var deliveryType = "Pickup"
    @State private var selectedPickupAddress = "234 Nguyễn Văn Lượng, Gò Vấp"
    @State private var guestName = "Trần An"
    @State private var guestAddress = "616/65 Lê Đức Thọ, phường 15, quận Gò Vấp, thành phố HCM"
    @State private var guestPhoneNumber = "0886768841"
    @State private var selectedPayment = "COD"
    
    @State private var navigateTo: String? = nil
    @State private var navigateToBillStatus: Bool = false
    
    let paymentMethods = [
        ("COD", "COD"),
        ("MOMO", "MOMO"),
        ("ZaloPay", "Zalopay"),
        ("PayPal", "PayPal")
    ]
    
    let pickupAddresses = [
        "234 Nguyễn Văn Lượng, Gò Vấp",
        "45 Quang Trung, Gò Vấp"
    ]
    
    @State private var showPayPalButton: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if cartManager.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            DeliveryMethodView(deliveryType: $deliveryType)
                            CustomerInfoView(
                                deliveryType: $deliveryType,
                                guestName: $guestName,
                                guestAddress: $guestAddress,
                                guestPhoneNumber: $guestPhoneNumber,
                                selectedPickupAddress: $selectedPickupAddress,
                                nearestStoreAddress: $nearestStoreAddress,
                                latnLonModel: latnLonModel
                            )
                            OrderReviewView(
                                cartManager: cartManager,
                                showDeleteConfirmation: $showDeleteConfirmation,
                                drinkToDelete: $drinkToDelete
                            )
                            PaymentMethodView(
                                selectedPayment: $selectedPayment,
                                paymentMethods: paymentMethods,
                                showPayPalButton: $showPayPalButton
                            )
                            TotalPriceAndPlaceOrderView(
                                cartManager: cartManager,
                                viewModel: _viewModel,
                                navigateTo: $navigateTo,
                                navigateToBillStatus: $navigateToBillStatus
                            )
                        }
                        .navigationTitle("Giỏ hàng")
                        .navigationBarTitleDisplayMode(.inline)
                        .alert("Bạn có chắc muốn xóa sản phẩm này không?", isPresented: $showDeleteConfirmation) {
                            AlertDialog(drinkToDelete: drinkToDelete, cartManager: cartManager)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func placeOrder() {
        guard !cartManager.cartItems.isEmpty else {
            print("Giỏ hàng trống.")
            return
        }
        print("Đơn hàng đã đặt thành công!")
    }
    
    private func updateNearestStore() {
        guard let userLocation = locationManager.userLocation else {
            print("User location not available yet.")
            return
        }
        if let nearestStore = latnLonModel.calculateNearestStore(userLocation: userLocation) {
            nearestStoreAddress = nearestStore.address
        } else {
            nearestStoreAddress = "Không tìm thấy cửa hàng gần."
        }
    }
    
    private func openPayPalInSafari() {
        let filePath = "http://localhost:8000/index.html"
        guard let url = URL(string: filePath) else {
            print("Invalid URL format: \(filePath)")
            return
        }
        
        print("Attempting to open URL: \(url)")
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("PayPal page opened successfully.")
            } else {
                print("Failed to open PayPal page.")
            }
        }
    }
}

struct EmptyCartView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var orderViewModel = OrderViewModel()
    @State private var navigateToBillStatus: Bool = false
    @State private var orderCount: Int = 0

    var body: some View {
        VStack {
            if orderCount == 0 {
                Text("Giỏ hàng của bạn trống!")
                    .font(.headline)
                    .padding()
            }
            if orderCount > 0 {
                Button(action: {
                    navigateToBillStatus = true
                }) {
                    Text("Xem trạng thái Order")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            } else {
                NavigationLink(destination: LandingPage().navigationBarBackButtonHidden(true)) {
                    Text("Order ngay!")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            NavigationLink(destination: BillStatusView().navigationBarBackButtonHidden(true), isActive: $navigateToBillStatus) { EmptyView() }
        }
        .navigationTitle("Xem giỏ hàng")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let userId = viewModel.currentUser?.id {
                fetchOrderCount(for: userId) { count in
                    orderCount = count
                    print(orderCount)
                }
            }
        }
    }
    private func fetchOrderCount(for userId: String, completion: @escaping (Int) -> Void) {
            let db = Firestore.firestore()
            db.collection("Orders")
                .whereField("userID", isEqualTo: userId)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching orders: \(error)")
                        completion(0)
                        return
                    }

                    let orderCount = querySnapshot?.documents.count ?? 0
                    completion(orderCount)
                }
        }
}


struct DeliveryMethodView: View {
    @Binding var deliveryType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hình thức nhận hàng:")
                .font(.headline)
            
            Picker("Hình thức nhận hàng", selection: $deliveryType) {
                Text("Ghé lấy").tag("Pickup")
                Text("Giao hàng").tag("Deliver")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding([.horizontal, .top])
    }
}

struct CustomerInfoView: View {
    @Binding var deliveryType: String
    @Binding var guestName: String
    @Binding var guestAddress: String
    @Binding var guestPhoneNumber: String
    @Binding var selectedPickupAddress: String
    @Binding var nearestStoreAddress: String
    var latnLonModel: LatnLon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Thông tin khách hàng:")
                .font(.headline)
            
            HStack {
                Text("Tên khách hàng:")
                Spacer()
                Text(guestName)
                    .foregroundColor(.gray)
            }
            
            if deliveryType == "Pickup" {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Chọn địa chỉ lấy hàng:")
                    Picker("Chọn địa chỉ", selection: $selectedPickupAddress) {
                        if nearestStoreAddress != "Đang xác định vị trí..." {
                            Text("Gần nhất: \(nearestStoreAddress)").tag(nearestStoreAddress)
                        }
                        
                        if latnLonModel.lat_lon_store.isEmpty {
                            Text("Đang tải địa chỉ...").tag("")
                        } else {
                            ForEach(latnLonModel.lat_lon_store, id: \.id) { store in
                                Text(store.address).tag(store.address)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            } else {
                HStack {
                    Text("Địa chỉ giao hàng:")
                    Spacer()
                    TextField("Nhập địa chỉ", text: $guestAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            HStack {
                Text("Số điện thoại:")
                Spacer()
                Text(guestPhoneNumber)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct OrderReviewView: View {
    @ObservedObject var cartManager: CartStore
    @Binding var showDeleteConfirmation: Bool
    @Binding var drinkToDelete: CartItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Đơn hàng của bạn")
                .font(.headline)
            
            List {
                ForEach(cartManager.cartItems) { item in
                    CartItemRow(item: item)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                drinkToDelete = item
                                showDeleteConfirmation = true
                            } label: {
                                Label("Xóa", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            .frame(height: 200)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct PaymentMethodView: View {
    @Binding var selectedPayment: String
    let paymentMethods: [(String, String)]
    @Binding var showPayPalButton: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Phương thức thanh toán:")
                .font(.headline)
            
            ForEach(paymentMethods, id: \.0) { method in
                HStack {
                    Image(method.1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)
                    
                    Text(method.0)
                    Spacer()
                    Image(systemName: selectedPayment == method.0 ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedPayment == method.0 ? .blue : .gray)
                        .onTapGesture {
                            selectedPayment = method.0
                            if method.0 == "PayPal" {
                                openPayPalInSafari()
                            }
                        }
                        .padding(.vertical, 5)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    private func openPayPalInSafari() {
        // Implementation for opening PayPal in Safari
    }
}

struct TotalPriceAndPlaceOrderView: View {
    @ObservedObject var cartManager: CartStore
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var navigateTo: String?
    @Binding var navigateToBillStatus: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Tổng cộng:")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("\(cartManager.totalPrice) VNĐ")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            Button(action: {
                if viewModel.userSession == nil {
                    navigateTo = "login-cart"
                } else {
                    cartManager.saveOrder(for: viewModel.currentUser!)
                    navigateToBillStatus = true
                }
            }) {
                Text("Đặt hàng")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: LoginView(source: navigateTo == "login-cart" ? "cart" : nil), tag: "login-cart", selection: $navigateTo) { EmptyView() }
            NavigationLink(destination: CartView(), tag: "cart", selection: $navigateTo) { EmptyView() }
            NavigationLink(destination: BillStatusView(), isActive: $navigateToBillStatus) { EmptyView() }
        }
        .padding(.horizontal)
    }
}

struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.drinkName)
                    .font(.headline)
                Text("Kích cỡ: \(item.size) | Đá: \(item.ice) | Đường: \(item.sugar)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Số lượng: \(item.quantity)")
                    .font(.subheadline)
            }
            Spacer()
            Text("\(item.totalPrice) VNĐ")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 5)
    }
}

struct AlertDialog: View {
    var drinkToDelete: CartItem?
    @ObservedObject var cartManager: CartStore
    
    var body: some View {
        Button("Hủy", role: .cancel) {}
        Button("Xóa", role: .destructive) {
            if let drink = drinkToDelete {
                cartManager.removeCartItem(drink.id)
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartStore())
    }
}

