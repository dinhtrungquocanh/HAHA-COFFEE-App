//
//  ModelData.swift
//  newHAHACOFFEE
//
//  Created by Phương An on 23/09/2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class ModelData : ObservableObject{
    @Published var drinks: [Features] = []

    
    var categories: [Features.Category: [Features]] {
        Dictionary(grouping: drinks, by: {$0.category})
    }
    
    // Localized categories dictionary
    var localizedCategories: [Features.Category: [Features]] {
        let currentLocale = Locale.current
        return Dictionary(grouping: drinks, by: { $0.category })
       }
    
    init() {
        fetchDrink()
    }
    
    func fetchDrink() {
        print("Starting fetchDrink...")
        drinks.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("DrinkMenu")
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching data from DrinkMenu: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No data found in snapshot.")
                return
            }
            
            print("Snapshot contains \(snapshot.documents.count) documents.")
            DispatchQueue.main.async {
                for document in snapshot.documents {
                    let data = document.data()
                    print("Document data: \(data)")
                    
                    if let feature = Features(data: data) {
                        self.drinks.append(feature)
                        print("Added drink: \(feature.drinkName)")
                    } else {
                        print("Failed to parse document: \(data)")
                    }
                }
                print("Final drinks count: \(self.drinks.count)")
            }
        }
    }
    
    func fetchOrder() {
        print("Starting fetchOrder...")
        let db_order = Firestore.firestore()
        let ref_order = db_order.collection("Orders")
        
        ref_order.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching data from Orders: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No data found in snapshot.")
                return
            }
            
        }
    }

    /*
    func fetchDrink() {
        drinks.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("DrinkMenu")
        
        ref.getDocuments {snapshot, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No data fround.")
                return
            }
            
            DispatchQueue.main.async {
                for document in snapshot.documents {
                    let data = document.data()
                    if let feature = Features(data: data) {
                        self.drinks.append(feature)
                    } else {
                        print("Failed to parse: \(data)")
                    }
                }
                print("Fetched drinks: \(self.drinks.count)")
            }
   
        }
    }
     */
}

