//
//  AdminView.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

import SwiftUI
import Charts

struct AdminView: View {
    @StateObject private var viewModel = AdminModel()
    @State private var showProfile = false // State to toggle profile view

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header Section
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Welcome to HAHA4LIFE")
                                .font(.title)
                                .bold()
                            Text("Choose The Category")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            showProfile.toggle() // Show profile when button is tapped
                        }) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                Text("Admin: Phuong An")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Search Bar
                    TextField("Search something", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    // Summary Cards
                    HStack(spacing: 20) {
                        SummaryCard(title: "Total Order", value: viewModel.totalOrders, percentage: -2.33, isPositive: false, systemImageName: "cart.fill")
                        SummaryCard(title: "New Customer", value: viewModel.newCustomers, percentage: 32.4, isPositive: true, systemImageName: "person.2.fill")
                        SummaryCard(title: "Total Sales", value: viewModel.totalRevenue, percentage: 25.0, isPositive: true, systemImageName: "dollarsign.circle.fill")
                    }
                    .padding(.horizontal)

                    .padding(.horizontal)

                    // Sales Analytics Chart
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Sales Analytics")
                                .font(.headline)
                            Spacer()
                            Button("See all") {
                                // Action for "See all"
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }

                        Chart(viewModel.salesData) { dataPoint in
                            LineMark(
                                x: .value("Hour", dataPoint.date, unit: .hour),
                                y: .value("Orders", dataPoint.revenue)
                            )
                            .foregroundStyle(.orange)
                            .symbol(Circle())
                            .interpolationMethod(.catmullRom)
                        }
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text("Most Trending Drinks")
                            .font(.headline)

                        if viewModel.mostTrendingDrinks.isEmpty {
                            Text("No trending drinks available.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.mostTrendingDrinks) { drink in
                                HStack {
                                    Text(drink.drinkName)
                                    Spacer()
                                    Text("\(drink.orderCount)")
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }



                    // Recent Orders
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Recent Orders")
                                .font(.headline)
                            Spacer()
                            Button("See all") {
                                // Action for "See all"
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        ForEach(viewModel.displayedOrders) { order in
                            HStack {
                                Text("#\(String(order.id.prefix(8)))") // Convert Substring to String
                                    .font(.subheadline)
                                Spacer()
                                Text(order.timestamp.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                Spacer()
                                Text("VND \(order.totalPrice)")
                                    .font(.subheadline)
                                    .bold()
                            }
                            .padding(.vertical, 5)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)


                }
            }
            .sheet(isPresented: $showProfile) {
                // Administrator Profile View
                VStack {
                    Text("Administrator Profile")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Text("Name: Phuong An")
                    Text("Role: Administrator")
                    Text("Email: phuongan@example.com")
                    Spacer()
                    Button("Close") {
                        showProfile = false
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: Double
    let percentage: Double
    let isPositive: Bool
    let systemImageName: String // New field for the system image

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: systemImageName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Spacer()
            }
            Text(title)
                .font(.headline)
            Text(String(format: "%.0f", value))
                .font(.title2)
                .bold()
            HStack {
                Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                    .foregroundColor(isPositive ? .green : .red)
                Text(String(format: "%.2f%%", percentage))
                    .foregroundColor(isPositive ? .green : .red)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

