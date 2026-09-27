//
//  Profile.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 30/12/24.
//

/*
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if let user = viewModel.currentUser {
                Text("Chào mừng, \(user.fullName)!")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    viewModel.logOut()
                }) {
                    Text("Đăng xuất")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            } else {
                Text("Bạn chưa đăng nhập.")
                    .font(.headline)
            }
        }
        .padding()
        .navigationTitle("Thông tin cá nhân")
    }
}


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateTo: String? = nil // Navigation tracking
    
    var body: some View {
        VStack {
            if let user = viewModel.currentUser {
                // Logged-in user details
                VStack(spacing: 10) {
                    Text(user.fullName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                            Text(user.email)
                        }
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                            Text(user.phoneNumber)
                        }
                    }
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    viewModel.logOut()
                }) {
                    Text("Đăng xuất")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            } else {
                // Redirect to login for non-logged-in users
                VStack {
                    Text("Bạn chưa đăng nhập.")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        navigateTo = "login_profile"
                    }) {
                        Text("Đăng nhập ngay")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Thông tin cá nhân")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false) // Ensure the back button is visible
        
        // Navigation Links
        NavigationLink(
            destination: LoginView(source: "profile"),
            tag: "login_profile",
            selection: $navigateTo
        ) {
            EmptyView()
        }
    }
}
*/

import SwiftUI
import MapKit

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateTo: String? = nil // Navigation tracking

    var body: some View {
        VStack {
            if let user = viewModel.currentUser {
                ScrollView {
                    VStack(spacing: 40) { // Increased spacing for better coverage
                        // Profile Picture
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                            Text(user.fullName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(user.id)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .padding(.top, 40)

                        // Divider
                        Divider()

                        // User Info Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text(user.email)
                            }
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                Text(user.phoneNumber)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                        // Add Address Button
                        Button(action: {
                            navigateTo = "map_view"
                        }) {
                            Text("Thêm địa chỉ ngay")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                        }

                        // Logout Button
                        Button(action: {
                            viewModel.logOut()
                        }) {
                            Text("Đăng xuất")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            } else {
                VStack(spacing: 20) {
                    Spacer() // Push content to the center vertically
                    Text("Bạn chưa đăng nhập.")
                        .font(.headline)
                        .padding(.bottom, 10)

                    Button(action: {
                        navigateTo = "login_profile"
                    }) {
                        Text("Đăng nhập ngay")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    Spacer() // Push content to the center vertically
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Center content horizontally and vertically
                .background(Color(.systemGray6).ignoresSafeArea()) // Background color
            }
        }
        .navigationTitle("Thông tin cá nhân")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)

        // Navigation Links
        NavigationLink(
            destination: LoginView(source: "profile"),
            tag: "login_profile",
            selection: $navigateTo
        ) {
            EmptyView()
        }
        NavigationLink(
            destination: MapView(orderDetails: ["orderId": "12345", "customerName": "Nguyen Thanh Hau"]),
            tag: "map_view",
            selection: $navigateTo
        ) {
            EmptyView()
        }
    }
}
