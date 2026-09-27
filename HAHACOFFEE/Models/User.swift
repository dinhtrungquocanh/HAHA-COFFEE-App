//
//  User.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 30/12/24.
//
import Foundation
import FirebaseFirestore


struct User: Identifiable, Codable {
    let id: String
    let email: String
    let fullName: String
    let phoneNumber: String
    let role: String
    let timeStamp: Date?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

