//
//  RegistrationView.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 16/12/2024.
//
/*
import SwiftUI
import Combine

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var role = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateTo: String? = nil // For navigation after registration

    let roles = ["customer", "shipper"]

    var body: some View {
        VStack {
            Image("LOGO")
                .resizable()
                .scaledToFit()
                .padding(.vertical, 32)

            Spacer()

            ScrollView {
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Địa chỉ Email",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)

                    InputView(text: $fullName,
                              title: "Họ tên đầy đủ",
                              placeholder: "Nguyễn Lý Anh Huy")

                    InputView(text: $phoneNumber,
                              title: "Số điện thoại",
                              placeholder: "09xxxxxxxxx")
                        .keyboardType(.numberPad)
                        .onReceive(Just(phoneNumber)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.phoneNumber = filtered
                            }
                        }

                    VStack(alignment: .leading) {
                        Text("Bạn muốn đăng ký trở thành: ")
                            .foregroundStyle(Color(.darkGray))
                            .fontWeight(.semibold)
                            .font(.footnote)

                        Picker("Bạn muốn đăng ký trở thành: ", selection: $role) {
                            ForEach(roles, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color(.darkGray))

                        Divider()
                    }

                    InputView(text: $password,
                              title: "Mật khẩu",
                              placeholder: "Nhập mật khẩu (Ít nhất 8 chữ)",
                              isSecureField: true)

                    InputView(text: $confirmPassword,
                              title: "Nhập lại mật khẩu",
                              placeholder: "Nhập lại mật khẩu của bạn",
                              isSecureField: true)
                }
            }

            Spacer()

            Button {
                Task {
                    do {
                        // Create user account
                        try await viewModel.createUser(
                            withEmail: email,
                            fullName: fullName,
                            phoneNumber: phoneNumber,
                            role: role,
                            password: password
                        )

                        // Determine where to navigate based on role
                        if let userRole = viewModel.navigateBasedOnRole() {
                            navigateTo = userRole
                            dismiss() // Dismiss RegistrationView
                        }
                    } catch {
                        print("DEBUG: Registration failed with error: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text(String(localized: "Đăng ký"))
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Bạn đã có tài khoản?")
                    Text("Đăng nhập ")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }

            Spacer()

            // Navigation Links for role-based navigation
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
        }
        .padding(30)
    }

    // Helper method to determine the destination view based on the role
    @ViewBuilder
    private func destinationView(for role: String?) -> some View {
        switch role {
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
}

struct RegistrationViewPreviews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
*/


import SwiftUI
import Combine

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var role = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String? = nil // For validation errors
    @State private var showError: Bool = false // To control the error message display
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var source: String? // Source of registration (e.g., "profile" or "cart")

    let roles = ["customer", "shipper"]

    var body: some View {
        VStack {
            Image("LOGO")
                .resizable()
                .scaledToFit()
                .padding(.vertical, 32)

            Spacer()

            ScrollView {
                VStack(spacing: 24) {
                    InputView(
                        text: $email,
                        title: "Địa chỉ Email",
                        placeholder: "name@example.com"
                    )
                    .autocapitalization(.none)

                    InputView(
                        text: $fullName,
                        title: "Họ tên đầy đủ",
                        placeholder: "Nguyễn Lý Anh Huy"
                    )

                    InputView(
                        text: $phoneNumber,
                        title: "Số điện thoại",
                        placeholder: "09xxxxxxxxx"
                    )
                    .keyboardType(.numberPad)
                    .onReceive(Just(phoneNumber)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.phoneNumber = filtered
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Bạn muốn đăng ký trở thành: ")
                            .foregroundStyle(Color(.darkGray))
                            .fontWeight(.semibold)
                            .font(.footnote)

                        Picker("Bạn muốn đăng ký trở thành: ", selection: $role) {
                            ForEach(roles, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color(.darkGray))

                        Divider()
                    }

                    InputView(
                        text: $password,
                        title: "Mật khẩu",
                        placeholder: "Nhập mật khẩu (Ít nhất 8 chữ)",
                        isSecureField: true
                    )

                    InputView(
                        text: $confirmPassword,
                        title: "Nhập lại mật khẩu",
                        placeholder: "Nhập lại mật khẩu của bạn",
                        isSecureField: true
                    )
                }
            }

            Spacer()

            if let errorMessage = errorMessage, showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.bottom, 10)
            }

            Button {
                if password.isEmpty || confirmPassword.isEmpty {
                    errorMessage = "Mật khẩu không được để trống."
                    showError = true
                } else if password != confirmPassword {
                    errorMessage = "Mật khẩu không khớp."
                    showError = true
                } else if password.count < 8 {
                    errorMessage = "Mật khẩu phải có ít nhất 8 ký tự."
                    showError = true
                } else {
                    Task {
                        do {
                            // Create user account
                            try await viewModel.createUser(
                                withEmail: email,
                                fullName: fullName,
                                phoneNumber: phoneNumber,
                                role: role,
                                password: password
                            )
                            
                            viewModel.loginSource = source // Update login source
                            dismiss() // Dismiss the RegistrationView
                        } catch {
                            errorMessage = "Đăng ký không thành công: \(error.localizedDescription)"
                            showError = true
                        }
                    }
                }
            } label: {
                Text("Đăng ký")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Bạn đã có tài khoản?")
                    Text("Đăng nhập ")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }

            Spacer()
        }
        .padding(30)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
    }
}

