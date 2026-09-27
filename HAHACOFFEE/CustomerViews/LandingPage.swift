//
//  LandingPage.swift
//  HAHApro
//
//  Created by Phương An on 24/09/2024.
//
/*
import SwiftUI

struct LandingPage: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateTo: String? = nil
    
    var body: some View {
        VStack {
            topBar
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.userSession == nil {
                        Button(action: {
                            navigateTo = "login-profile" // Profile button login
                        }) {
                            Text("Đăng Nhập/Đăng Ký")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                
                // Navigation Links for dynamic navigation
                
                // Navigation Links
                NavigationLink(
                    destination: LoginView(source: navigateTo == "login-profile" ? "profile" : "cart"),
                    tag: "login-profile",
                    selection: $navigateTo
                ) { EmptyView() }
                
                NavigationLink(destination: ProfileView(), tag: "profile", selection: $navigateTo) { EmptyView() }
                
                /*
                NavigationLink(
                    destination: destinationView(for: navigateTo),
                    tag: "login",
                    selection: $navigateTo
                ) { EmptyView() }
                
                NavigationLink(
                    destination: destinationView(for: navigateTo),
                    tag: "customer",
                    selection: $navigateTo
                ) { EmptyView() }
                
                NavigationLink(
                    destination: destinationView(for: navigateTo),
                    tag: "admin",
                    selection: $navigateTo
                ) { EmptyView() }
                
                NavigationLink(
                    destination: destinationView(for: navigateTo),
                    tag: "shipper",
                    selection: $navigateTo
                ) { EmptyView() }
                
                NavigationLink(
                    destination: destinationView(for: navigateTo),
                    tag: "staff",
                    selection: $navigateTo
                ) { EmptyView() }
                */
                // Add topSection, buttonSection, and drinkSection here
                topSection
                buttonSection
                drinkSection
            }
            .padding(.vertical)
        }
          .background(Color.white.ignoresSafeArea())
          .onAppear {
              modelData.fetchDrink()
          }
      }

      // Helper to determine destination based on the role
      @ViewBuilder
      private func destinationView(for role: String?) -> some View {
          switch role {
          case "login":
              LoginView()
          case "customer":
              ProfileView()
          case "admin":
              AdminView()
          case "shipper":
              StaffView()
          case "staff":
              StaffView()
          default:
              EmptyView()
          }
      }

    // Extracting the top bar into a computed property
    var topBar: some View {
        HStack {
            Button(action: {}, label: {
                Image(systemName: "circle.grid.2x2")
                    .font(.title2)
                    .padding(10)
                    .background(Color.pink.opacity(0.1))
                    .foregroundColor(.pink)
                    .cornerRadius(8.0)
            })
            Spacer()
            Button(action: {navigateTo = "profile"}, label: {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .padding(10)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8.0)
            })
        }
        .overlay(
            HStack(spacing: 4) {
                Image("mapmarker")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.red)
                Text("Thành phố Thủ Đức")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        )
        .padding()
    }

    // Extracting the top section into a separate view
    var topSection: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Bạn uống gì?")
                    .font(.title)
                    .fontWeight(.bold)
                Text("HAHA khao!")
                    .font(.title)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                Button(action: {}, label: {
                    Text("Order ngay")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.color2)
                        .clipShape(Capsule())
                })
            }
            .padding(.leading)
            Spacer(minLength: 0)
            Image("coffee")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: getRect().width / 3)
        }
        .padding()
        .background(.color1)
        .cornerRadius(15)
        .padding(.horizontal, 30)
    }

    // Extracting the button section into a separate view
    var buttonSection: some View {
        HStack(spacing: 10) {
            Button(action: {}, label: {
                Image("coffeeshop")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 150)
                    .cornerRadius(10)
                    .padding(.leading, 16)
            })
            Spacer()
            Button(action: {}, label: {
                Image("Shipper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 150)
                    .padding(.trailing, 0)
                    .padding(.bottom, 5)
                    .cornerRadius(15)
                    .padding(.trailing, 16)
            })
        }
        .padding(.horizontal)
    }

    // Updated drinkSection to integrate CategoryRow for displaying categories
    var drinkSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if modelData.drinks.isEmpty {
                Text("No drinks available.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    Text(key.rawValue) // Use rawValue if `Category` is an enum
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(modelData.categories[key]!, id: \.id) { drink in
                                    NavigationLink(
                                        destination: CoffeeOrderView2(drink: drink)
                                    ) {
                                        FeatureView(feature: drink, isCompact: true)
                                    }
                                }
                            }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
            .environmentObject(ModelData()) // Provide environment object for preview
    }
}
*/

import SwiftUI

struct LandingPage: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateTo: String? = nil
    @EnvironmentObject var languageSettings: LanguageSetting
    @Environment(\.locale) var locale
    
    var body: some View {
        VStack {
            topBar
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.userSession == nil {
                        Button(action: {
                            navigateTo = "login-profile" // Profile button login
                        }) {
                            Text("Đăng Nhập/Đăng Ký")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                
                // Navigation Links for dynamic navigation
                NavigationLink(
                    destination: LoginView(source: navigateTo == "login-profile" ? "profile" : nil),
                    tag: "login-profile",
                    selection: $navigateTo
                ) { EmptyView() }
                
                NavigationLink(destination: ProfileView(), tag: "profile", selection: $navigateTo) { EmptyView() }
                
                NavigationLink(destination: StaffView(), tag: "staff", selection: $navigateTo) { EmptyView() }
                
                // Add topSection, buttonSection, and drinkSection here
                topSection
                buttonSection
                drinkSection
            }
            .padding(.vertical)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            modelData.fetchDrink()
            handleRoleBasedNavigation()
        }
    }

    // Helper function to handle role-based navigation
    private func handleRoleBasedNavigation() {
        guard let userRole = viewModel.currentUser?.role else { return }
        
        switch userRole {
        case "staff", "shipper":
            navigateTo = "staff"
        case "customer":
            navigateTo = "profile"
        case "admin":
            navigateTo = "admin"
        default:
            break
        }
    }

    // Extracting the top bar into a computed property
    var topBar: some View {
        HStack {
            Button(action: {}, label: {
                Image(systemName: "circle.grid.2x2")
                    .font(.title2)
                    .padding(10)
                    .background(Color.pink.opacity(0.1))
                    .foregroundColor(.pink)
                    .cornerRadius(8.0)
            })
            Spacer()
            Button(action: { navigateTo = "profile" }, label: {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .padding(10)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(8.0)
            })
        }
        .overlay(
            HStack(spacing: 4) {
                Image("mapmarker")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.red)
                Text("Thành phố Thủ Đức")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        )
        .padding()
    }

    // Extracting the top section into a separate view
    var topSection: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Bạn uống gì?")
                    .font(.title)
                    .fontWeight(.bold)
                Text("HAHA khao!")
                    .font(.title)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                Button(action: {}, label: {
                    Text("Order ngay")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.color2)
                        .clipShape(Capsule())
                })
            }
            .padding(.leading)
            Spacer(minLength: 0)
            Image("coffee")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: getRect().width / 3)
        }
        .padding()
        .background(.color1)
        .cornerRadius(15)
        .padding(.horizontal, 30)
    }

    // Extracting the button section into a separate view
    var buttonSection: some View {
        HStack(spacing: 10) {
            Button(action: {}, label: {
                Image(languageSettings.locale.identifier == "en" ? "coffeeshop_english" : "coffeeshop")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 150)
                    .cornerRadius(10)
                    .padding(.leading, 16)
            })
            Spacer()
            Button(action: {}, label: {
                Image(languageSettings.locale.identifier == "en" ? "shipper_english" : "Shipper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 150)
                    .padding(.trailing, 0)
                    .padding(.bottom, 5)
                    .cornerRadius(15)
                    .padding(.trailing, 16)
            })
        }
        .padding(.horizontal)
    }
    

    // Updated drinkSection to integrate CategoryRow for displaying categories
    var drinkSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if modelData.drinks.isEmpty {
                Text("Không tìm thấy sản phẩm nào...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else if languageSettings.locale.identifier == "en"{
                ForEach(modelData.localizedCategories.keys.sorted(), id: \.self) { category in
                    Text(category.localized(locale: locale)) // Use rawValue if `Category` is an enum
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(modelData.localizedCategories[category]!, id: \.id) { drink in
                                    NavigationLink(
                                        destination: CoffeeOrderView2(drink: drink)
                                    ) {
                                        FeatureView(feature: drink, isCompact: true)
                                    }
                                }
                            }
                        .padding(.horizontal)
                    }
                }
            } else {
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    Text(key.rawValue) // Use rawValue if `Category` is an enum
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(modelData.categories[key]!, id: \.id) { drink in
                                    NavigationLink(
                                        destination: CoffeeOrderView2(drink: drink)
                                    ) {
                                        FeatureView(feature: drink, isCompact: true)
                                    }
                                }
                            }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
            .environmentObject(ModelData()) // Provide environment object for preview
    }
}

