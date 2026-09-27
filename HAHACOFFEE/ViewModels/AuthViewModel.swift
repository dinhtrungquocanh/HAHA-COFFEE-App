//
//  AuthViewModel.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 30/12/24.
//

/*
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // Tracks the current Firebase user session
    @Published var currentUser: User?             // Stores the current user's details
    @Published var role: String?                  // Tracks the user's role for navigation

    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser() // Fetch user info on initialization
        }
    }

    /// Logs in the user with email and password
    func logIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser() // Fetch user details after login

            // Update the role after login
            self.role = currentUser?.role
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }

    /// Creates a new user in Firebase Authentication and Firestore
    func createUser(withEmail email: String, fullName: String, phoneNumber: String, role: String, password: String) async throws {
        do {
            // Create user in Firebase Authentication
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user

            // Prepare user data
            let user = User(
                id: result.user.uid,
                email: email,
                fullName: fullName,
                phoneNumber: phoneNumber,
                role: role,
                timeStamp: Date()
            )

            // Save user data to Firestore
            let userData: [String: Any] = [
                "id": result.user.uid,
                "email": email,
                "fullName": fullName,
                "role": role,
                "phoneNumber": phoneNumber,
                "timeStamp": FieldValue.serverTimestamp()
            ]
            try await Firestore.firestore().collection("User").document(result.user.uid).setData(userData)

            // Update the currentUser property and role
            self.currentUser = user
            self.role = role

            print("DEBUG: User created successfully with role \(role)")
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }

    /// Logs out the user and resets session details
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.role = nil
        } catch {
            print("DEBUG: Failed to log out with error \(error.localizedDescription)")
        }
    }

    /// Fetches the current user from Firestore
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.currentUser = nil
            self.role = nil
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("User").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
            self.role = currentUser?.role // Update role after fetching user details
            print("DEBUG: User fetched successfully: \(self.currentUser?.fullName ?? "Unknown") with role \(self.role ?? "Unknown")")
        } catch {
            print("DEBUG: Failed to fetch user - \(error.localizedDescription)")
        }
    }

    /// Navigates based on the user's role
    func navigateBasedOnRole() -> String? {
        guard let role = currentUser?.role else {
            return nil // Return nil if role is not available
        }

        print("DEBUG: Navigating based on role: \(role)")
        return role // Returns the role as a string (e.g., "customer", "admin")
    }
}
*/

//
//  AuthViewModel.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 16/12/2024.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLanguageSelected: Bool = false
    @Published var role: String? = nil
    @Published var userSession: FirebaseAuth.User? = nil
    @Published var currentUser: User? = nil
    @Published var currentLanguage: String = "en"
    @Published var loginSource: String? = nil // Track the source of login

    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser() // Fetch user info on initialization
        }
    }

    func logIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()

            self.role = currentUser?.role
        } catch {
            print("DEBUG: Failed to log in - \(error.localizedDescription)")
            throw error
        }
    }

    func createUser(withEmail email: String, fullName: String, phoneNumber: String, role: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user

            let user = User(id: result.user.uid, email: email, fullName: fullName, phoneNumber: phoneNumber, role: role, timeStamp: Date())

            let userData: [String: Any] = [
                "id": result.user.uid,
                "email": email,
                "fullName": fullName,
                "phoneNumber": phoneNumber,
                "role": role,
                "timeStamp": FieldValue.serverTimestamp()
            ]
            try await Firestore.firestore().collection("User").document(result.user.uid).setData(userData)

            self.currentUser = user
            self.role = role

            navigateBasedOnRole() // Update the role after registration
        } catch {
            print("DEBUG: Failed to create user - \(error.localizedDescription)")
            throw error
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.role = nil
            self.isLanguageSelected = false
            self.loginSource = nil // Reset login source
        } catch {
            print("DEBUG: Failed to log out - \(error.localizedDescription)")
        }
    }

    func selectLanguage(language: String) {
        currentLanguage = language
        isLanguageSelected = true
    }

    func resetToContentView() {
        isLanguageSelected = false
        // Preserve role and user session to allow redirection after language selection
    }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.currentUser = nil
            self.role = nil
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("User").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
            self.role = currentUser?.role
        } catch {
            self.currentUser = nil
            self.role = nil
        }
    }

    func navigateBasedOnRole() {
        guard let role = currentUser?.role else {
            print("DEBUG: No role found for the current user.")
            return
        }
        self.role = role
        print("DEBUG: Navigating based on role: \(role)")
    }
}

