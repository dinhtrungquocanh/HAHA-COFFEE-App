//
//  LogInView.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 16/12/2024.
//

/*
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var source: String?
    
    @State var navigateTo: String? = nil // For navigation after login
    @State var hideBackButton: Bool
    @State private var errorMessage: String? // To display error messages
    @State private var showError: Bool = false // Controls the error alert

    var body: some View {
        VStack {
            Image("LOGO")
                .resizable()
                .scaledToFit()

            Spacer()

            VStack(spacing: 24) {
                InputView(
                    text: $email,
                    title: "Địa chỉ Email",
                    placeholder: "name@example.com"
                )
                .autocapitalization(.none)

                InputView(
                    text: $password,
                    title: "Mật khẩu",
                    placeholder: "Nhập mật khẩu",
                    isSecureField: true
                )
            }

            Spacer()

            Button {
                Task {
                    do {
                        try await viewModel.logIn(withEmail: email, password: password)
                        
                        // Get the role and navigate accordingly
                        if let userRole = viewModel.navigateBasedOnRole() {
                            navigateTo = userRole
                            presentationMode.wrappedValue.dismiss() // Dismiss LoginView
                        }
                    } catch {
                        print("DEBUG: Login failed with error: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Đăng nhập")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()

            // Sign-up navigation
            NavigationLink {
                RegistrationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Bạn chưa có tài khoản?")
                    Text("Đăng ký")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }

            Spacer()

            // Navigation Links for role-based redirection
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
        .navigationBarBackButtonHidden(hideBackButton) // Show/hide back button dynamically
    }

    // Helper method to return the appropriate destination view
    @ViewBuilder
    func destinationView(for role: String?) -> some View {
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

struct ShipperView: View {
    var body: some View {
        Text("Welcome, Shipper!")
    }
}

struct AdminView: View {
    var body: some View {
        Text("Welcome, Admin!")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(hideBackButton: false)
    }
}

*/

/*
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject private var adminviewModel = AdminModel()
    @State private var isAdminLoggedIn = false

    var source: String? // Source of login (e.g., "profile" or "cart")

    @State private var errorMessage: String? // To display error messages
    @State private var showError: Bool = false // Controls the error alert

    var body: some View {
        VStack {
            Image("LOGO")
                .resizable()
                .scaledToFit()

            Spacer()

            VStack(spacing: 24) {
                InputView(
                    text: $email,
                    title: "Địa chỉ Email",
                    placeholder: "name@example.com"
                )
                .autocapitalization(.none)

                InputView(
                    text: $password,
                    title: "Mật khẩu",
                    placeholder: "Nhập mật khẩu",
                    isSecureField: true
                )
                

            }
            

            Spacer()

            Button {
                Task {
                    do {
                        try await viewModel.logIn(withEmail: email, password: password)
                        viewModel.loginSource = source // Update login source
                        dismiss() // Dismiss LoginView
                    } catch {
                        handleLoginError(error) // Handle specific error
                    }
                }
                
            } label: {
                Text("Đăng nhập")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
            
            /*
            // Navigation to AdminView
            NavigationLink(destination: AdminView(), isActive: $isAdminLoggedIn) {
                EmptyView()
            }
*/
            NavigationLink {
                RegistrationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Bạn chưa có tài khoản?")
                    Text("Đăng ký")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }

            Spacer()
        }
        .padding(30)
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Lỗi Đăng Nhập"),
                message: Text(errorMessage ?? "Đã xảy ra lỗi không xác định."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    /// Handle specific Firebase login errors
    private func handleLoginError(_ error: Error) {
        if let error = error as NSError? {
            print("DEBUG: Error Code - \(error.code), Description - \(error.localizedDescription)")

            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .wrongPassword:
                    errorMessage = "Sai mật khẩu. Vui lòng thử lại."
                case .invalidEmail:
                    errorMessage = "Email không hợp lệ. Vui lòng kiểm tra lại."
                case .userNotFound:
                    errorMessage = "Email không tồn tại trong hệ thống. Vui lòng kiểm tra hoặc đăng ký tài khoản mới."
                case .invalidCredential:
                    errorMessage = "Thông tin đăng nhập không chính xác. Vui lòng thử lại."
                case .networkError:
                    errorMessage = "Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng."
                case .userDisabled:
                    errorMessage = "Tài khoản của bạn đã bị vô hiệu hóa."
                default:
                    errorMessage = "Đã xảy ra lỗi không xác định. Vui lòng thử lại."
                }
            } else {
                errorMessage = "Đã xảy ra lỗi không xác định. Vui lòng thử lại."
                print("DEBUG: Unable to match error code to AuthErrorCode.")
            }
        } else {
            errorMessage = "Đã xảy ra lỗi không xác định. Vui lòng thử lại."
            print("DEBUG: Error could not be cast as NSError.")
        }

        showError = true // Trigger the alert
    }
}

struct ShipperView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Custom Back Button
            HStack {
                Button(action: {
                    viewModel.resetToContentView() // Reset state to navigate to ContentView
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Back arrow icon
                            .font(.headline)
                        Text("Back") // Back button text
                            .font(.headline)
                    }
                }
                .padding()
                Spacer()
            }

            Text("Welcome, Shipper!")
                .font(.largeTitle)

            Spacer()

            Button(action: {
                viewModel.logOut() // Log out the user
            }) {
                Text("Đăng xuất")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onChange(of: viewModel.isLanguageSelected) { isLanguageSelected in
            if !isLanguageSelected {
                presentationMode.wrappedValue.dismiss() // Navigate back when language is reset
            }
        }
        .navigationBarHidden(true) // Hide the default navigation bar
    }
}

/*
struct AdminView: View {
    var body: some View {
        Text("Welcome, Admin!")
    }
}
*/

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}


*/

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var source: String? // Source of login (e.g., "profile" or "cart")

    @State private var errorMessage: String? // To display error messages
    @State private var showError: Bool = false // Controls the error alert

    var body: some View {
        VStack {
            Image("LOGO")
                .resizable()
                .scaledToFit()

            Spacer()

            VStack(spacing: 24) {
                InputView(
                    text: $email,
                    title: "Địa chỉ Email",
                    placeholder: "name@example.com"
                )
                .autocapitalization(.none)

                InputView(
                    text: $password,
                    title: "Mật khẩu",
                    placeholder: "Nhập mật khẩu",
                    isSecureField: true
                )
            }

            Spacer()

            Button {
                Task {
                    do {
                        try await viewModel.logIn(withEmail: email, password: password)
                        viewModel.loginSource = source // Update login source
                        dismiss() // Dismiss LoginView
                    } catch {
                        handleLoginError(error) // Handle specific error
                    }
                }
            } label: {
                Text("Đăng nhập")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()

            NavigationLink {
                RegistrationView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Bạn chưa có tài khoản?")
                    Text("Đăng ký")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }

            Spacer()
        }
        .padding(30)
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Lỗi Đăng Nhập"),
                message: Text(errorMessage ?? "Đã xảy ra lỗi không xác định."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    /// Handle specific Firebase login errors
    private func handleLoginError(_ error: Error) {
        if let error = error as NSError? {
            print("DEBUG: Error Code - \(error.code), Description - \(error.localizedDescription)")

            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .wrongPassword:
                    errorMessage = "Sai mật khẩu. Vui lòng thử lại."
                case .invalidEmail:
                    errorMessage = "Email không hợp lệ. Vui lòng kiểm tra lại."
                case .userNotFound:
                    errorMessage = "Email không tồn tại trong hệ thống. Vui lòng kiểm tra hoặc đăng ký tài khoản mới."
                case .invalidCredential:
                    errorMessage = "Thông tin đăng nhập không chính xác. Vui lòng thử lại."
                case .networkError:
                    errorMessage = "Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng."
                case .userDisabled:
                    errorMessage = "Tài khoản của bạn đã bị vô hiệu hóa."
                default:
                    errorMessage = "Đã xảy ra lỗi không xác định. Vui lòng thử lại."
                }
            } else {
                errorMessage = "Đã xảy ra lỗi không xác định. Vui lòng thử lại."
                print("DEBUG: Unable to match error code to AuthErrorCode.")
            }
        } else {
            errorMessage = "Đã xảy ra lỗi không xác định. Vui lòng thử lại."
            print("DEBUG: Error could not be cast as NSError.")
        }

        showError = true // Trigger the alert
    }
}

struct ShipperView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Custom Back Button
            HStack {
                Button(action: {
                    viewModel.resetToContentView() // Reset state to navigate to ContentView
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Back arrow icon
                            .font(.headline)
                        Text("Back") // Back button text
                            .font(.headline)
                    }
                }
                .padding()
                Spacer()
            }

            Text("Chào mừng, Shipper!")
                .font(.largeTitle)

            Spacer()

            Button(action: {
                viewModel.logOut() // Log out the user
            }) {
                Text("Đăng xuất")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onChange(of: viewModel.isLanguageSelected) { isLanguageSelected in
            if !isLanguageSelected {
                presentationMode.wrappedValue.dismiss() // Navigate back when language is reset
            }
        }
        .navigationBarHidden(true) // Hide the default navigation bar
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}


