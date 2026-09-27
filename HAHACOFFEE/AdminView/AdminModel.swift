//
//  AdminModel.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

import FirebaseFirestore
import SwiftUI
import Combine

class AdminModel: ObservableObject {
    @Published var orders: [Orders] = [] // All orders fetched from Firebase
    @Published var displayedOrders: [Orders] = [] // Filtered or raw orders to be passed to the view
    @Published var mostTrendingDrinks: [TrendingDrink] = [] // Observable trending drinks
    @Published var totalOrders: Double = 0.0 // Total orders
    @Published var newCustomers: Double = 0.0
    @Published var newCustomerPercentageChange: Double = 0.0
    @Published var isNewCustomerIncrease: Bool = true
    @Published var totalRevenue: Double = 0.0
    @Published var revenuePercentageChange: Double = 0.0
    @Published var isRevenueIncrease: Bool = true
    @Published var salesData: [SalesDataPoint] = [] // Sales data for the chart
    @Published var errorMessage: String? = nil // For error feedback

    private let db = Firestore.firestore() // Firebase Firestore reference

    // Selected timeframe for analytics
    @Published var selectedTimeframe: Int = 2 // Default: 2 days

    init() {
        fetchOrders_admin() // Fetch orders when the model is initialized
    }
    
    /*

    func fetchOrders() {
        db.collection("Orders")
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching orders: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No orders found.")
                    return
                }

                let fetchedOrders = documents.compactMap { Orders(documentId: doc.documentID, dictionary: $0.data()) }
                print("Fetched Orders: \(fetchedOrders.count)")

                DispatchQueue.main.async {
                    self?.orders = fetchedOrders
                    self?.applyFilter()
                    self?.updateStatistics()
                    self?.calculateTrendingDrinks() // Ensure this is called
                }
            }
    }
     */
    
    // Fetch orders from Firebase
    func fetchOrders_admin() {
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



    func applyFilter() {
        DispatchQueue.main.async {
            self.displayedOrders = self.orders.filter { $0.shipping && $0.payment }
            print("Filtered Completed Orders: \(self.displayedOrders.count)")
        }
    }

    func updateStatistics() {
        calculateTotalOrders()
        calculateNewCustomers()
        calculateRevenue()
        calculateSalesData()
    }

    func calculateTotalOrders() {
        self.totalOrders = Double(orders.count)
        print("Total Orders: \(self.totalOrders)")
    }
    func fetchFeatures(completion: @escaping ([Features]) -> Void) {
        db.collection("Features")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching features: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let features = snapshot?.documents.compactMap { Features(data: $0.data()) } ?? []
                completion(features)
            }
    }

    func calculateNewCustomers() {
        let calendar = Calendar.current
        let latestDay = calendar.date(from: DateComponents(year: 2024, month: 12, day: 30))!
        let previousDay = calendar.date(from: DateComponents(year: 2024, month: 12, day: 29))!

        let todayCustomers = orders.filter { $0.timestamp >= latestDay && $0.timestamp < latestDay.addingTimeInterval(86400) }.count
        let yesterdayCustomers = orders.filter { $0.timestamp >= previousDay && $0.timestamp < latestDay }.count

        self.newCustomers = Double(todayCustomers)
        if yesterdayCustomers > 0 {
            self.newCustomerPercentageChange = ((Double(todayCustomers) - Double(yesterdayCustomers)) / Double(yesterdayCustomers)) * 100
        } else {
            self.newCustomerPercentageChange = todayCustomers > 0 ? 100 : 0
        }
        self.isNewCustomerIncrease = self.newCustomerPercentageChange >= 0

        print("New Customers (30th Dec): \(todayCustomers), Previous Day (29th Dec): \(yesterdayCustomers)")
    }


    func calculateRevenue() {
        let calendar = Calendar.current
        let latestDay = calendar.date(from: DateComponents(year: 2024, month: 12, day: 30))!
        let previousDay = calendar.date(from: DateComponents(year: 2024, month: 12, day: 29))!

        let todayRevenue = orders.filter { $0.timestamp >= latestDay && $0.timestamp < latestDay.addingTimeInterval(86400) }
            .reduce(0) { $0 + Double($1.totalPrice) }
        let yesterdayRevenue = orders.filter { $0.timestamp >= previousDay && $0.timestamp < latestDay }
            .reduce(0) { $0 + Double($1.totalPrice) }

        self.totalRevenue = todayRevenue
        if yesterdayRevenue > 0 {
            self.revenuePercentageChange = ((todayRevenue - yesterdayRevenue) / yesterdayRevenue) * 100
        } else {
            self.revenuePercentageChange = todayRevenue > 0 ? 100 : 0
        }
        self.isRevenueIncrease = self.revenuePercentageChange >= 0

        print("Revenue (30th Dec): \(todayRevenue), Revenue (29th Dec): \(yesterdayRevenue)")
    }


    func calculateSalesData() {
        let calendar = Calendar.current
        let latestDay = calendar.date(from: DateComponents(year: 2024, month: 12, day: 30))!

        var hourlyData: [Date: Int] = [:]

        for order in orders where order.timestamp >= latestDay && order.timestamp < latestDay.addingTimeInterval(86400) {
            let hour = calendar.date(bySettingHour: calendar.component(.hour, from: order.timestamp),
                                     minute: 0,
                                     second: 0,
                                     of: order.timestamp)!
            hourlyData[hour, default: 0] += 1
        }

        self.salesData = hourlyData.map { SalesDataPoint(id: UUID(), date: $0.key, revenue: Double($0.value)) }
            .sorted { $0.date < $1.date }

        print("Sales Data for 30th Dec:")
        self.salesData.forEach { print("Hour: \($0.date), Orders: \($0.revenue)") }
    }
    func calculateMonthlySalesData() -> [MonthlySalesData] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"

        var monthlyData: [String: (units: Int, totalValue: Double)] = [:]

        for order in orders {
            let month = formatter.string(from: order.timestamp)
            if let current = monthlyData[month] {
                monthlyData[month] = (units: current.units + 1, totalValue: current.totalValue + Double(order.totalPrice))
            } else {
                monthlyData[month] = (units: 1, totalValue: Double(order.totalPrice))
            }
        }

        return monthlyData.map { month, data in
            MonthlySalesData(
                month: month,
                unitsOrdered: data.units,
                averageOrderValue: data.totalValue / Double(data.units)
            )
        }.sorted { $0.month < $1.month }
    }
  
    // Calculate trending drinks
    func calculateTrendingDrinks() {
        var drinkCounts: [String: Int] = [:]
        for order in orders {
            print("Order ID: \(order.id), Items: \(order.items)") // Debug log
            for item in order.items {
                print("Drink: \(item.drinkName), Quantity: \(item.quantity)") // Debug log
                drinkCounts[item.drinkName, default: 0] += item.quantity
            }
        }

        self.mostTrendingDrinks = drinkCounts.map { TrendingDrink(drinkName: $0.key, orderCount: $0.value) }
            .sorted { $0.orderCount > $1.orderCount }
        
        print("Most Trending Drinks: \(self.mostTrendingDrinks)") // Debug log
    }



}

struct TrendingDrink: Identifiable {
    let id = UUID()
    let drinkName: String
    let orderCount: Int
}


struct SalesDataPoint: Identifiable {
    let id: UUID
    let date: Date
    let revenue: Double
}
struct MonthlySalesData: Identifiable {
    let id = UUID()
    let month: String
    let unitsOrdered: Int
    let averageOrderValue: Double
}


