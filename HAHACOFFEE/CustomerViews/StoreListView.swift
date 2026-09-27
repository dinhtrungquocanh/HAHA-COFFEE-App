//
//  StoreListView.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

import Foundation
import SwiftUI

struct StoreListView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var searchText: String = ""
    @State private var selectedCategory: Features.Category? = nil
    @State private var isFilterMenuPresented: Bool = false
    
    // Computed property for filtered drinks
    var filteredDrinks: [Features] {
        modelData.drinks
            .filter { $0.category != .program } // Exclude "SỰ KIỆN ✨"
            .filter { drink in
                searchText.isEmpty || drink.drinkName.lowercased().contains(searchText.lowercased())
            }
            .filter { drink in
                selectedCategory == nil || drink.category == selectedCategory
            }
    }
    
    var body: some View {
        VStack {
            // Search Bar and Filter
            VStack {
                HStack {
                    TextField("Đang tìm sản phẩm...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                HStack {
                    Button(action: {
                        isFilterMenuPresented.toggle()
                    }) {
                        Label("Lọc", systemImage: "line.horizontal.3.decrease.circle")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .actionSheet(isPresented: $isFilterMenuPresented) {
                        ActionSheet(
                            title: Text("Lọc theo"),
                            buttons: filterActionSheetButtons()
                        )
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            // Main Content Area
            if filteredDrinks.isEmpty {
                Spacer() // Push content to the top
                VStack {
                    Text("Không tìm thấy sản phẩm nào.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer() // Push content to the bottom
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(filteredDrinks, id: \.id) { drink in
                            NavigationLink(
                                destination: CoffeeOrderView2(drink: drink)
                            ) {
                                VStack {
                                    drink.image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                    Text(drink.drinkName)
                                        .font(.headline)
                                        .lineLimit(1)
                                    Text(drink.price)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Menu")
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure the VStack takes up the full screen
        .background(Color(.systemBackground))
    }
    
    // Helper function to create action sheet buttons for categories
    private func filterActionSheetButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = Features.Category.allCases
            .filter { $0 != .program } // Exclude "SỰ KIỆN ✨"
            .sorted()
            .map { category in
                .default(Text(category.rawValue)) {
                    selectedCategory = category
                }
            }
        
        // Add a reset option
        buttons.append(.default(Text("Hiện tất cả")) {
            selectedCategory = nil
        })
        
        // Add a cancel button
        buttons.append(.cancel())
        
        return buttons
    }
}


#Preview {
    MenuView()
}

