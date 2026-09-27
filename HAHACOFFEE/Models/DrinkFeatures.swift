//
//  Features.swift
//  newHAHACOFFEE
//
//  Created by Phương An on 23/09/2024.
//


import Foundation
import SwiftUI
import CoreLocation

struct Features: Hashable, Identifiable {
    var id: String
    var drinkName: String
    var drinkName_en: String
    var price: String
    var description: String
    var description_en: String
    var ingredients: String
    var ingredients_en: String
    var category: Category
    var imageName: String
    var type: DrinkType
    
    
    var image: Image {
        Image(imageName) // Uses the imageName variable to create an Image
    }

    /// Initializer for decoding from Firebase data
    init?(data: [String: Any]) {
        guard
            let id = data["id"] as? String,
            let drinkName = data["drinkName"] as? String,
            let drinkName_en = data["drinkName_en"] as? String,
            let price = data["price"] as? String,
            let description = data["description"] as? String,
            let description_en = data["description_en"] as? String,
            let ingredients = data["ingredients"] as? String,
            let ingredients_en = data["ingredients_en"] as? String,
            let categoryRawValue = data["category"] as? String,
            let imageName = data["imageName"] as? String,
            let drinkTypeRawValue = data["type"] as? String
        else {
            return nil
        }

        self.id = id
        self.drinkName = drinkName
        self.drinkName_en = drinkName_en
        self.price = price
        self.description = description
        self.description_en = description_en
        self.ingredients = ingredients
        self.ingredients_en = ingredients_en
        self.category = Category.from(rawValue: categoryRawValue)
        self.imageName = imageName
        self.type = DrinkType.from(rawValue: drinkTypeRawValue)
    }

    enum Category: String, CaseIterable, Codable, Comparable {
        case bestsellers = "BÁN CHẠY NHẤT ✨"
        case foryou = "DÀNH CHO BẠN ✨"
        case musttry = "MÓN NGON PHẢI THỬ ✨"
        case program = "SỰ KIỆN ✨"
        
        // Define an order for the categories
        static func < (lhs: Category, rhs: Category) -> Bool {
            let order: [Category] = [.bestsellers, .foryou, .musttry, .program]
            return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
        }
        
        // Fallback case for invalid categories
        static func from(rawValue: String) -> Category {
            return Category(rawValue: rawValue) ?? .foryou
        }

        // Computed property for localization
        func localized(locale: Locale) -> String  {
            switch self {
            case .bestsellers: return NSLocalizedString("BÁN CHẠY NHẤT ✨", comment: "Localized string for bestsellers")
            case .foryou: return NSLocalizedString("DÀNH CHO BẠN ✨", comment: "Localized string for for you")
            case .musttry: return NSLocalizedString("MÓN NGON PHẢI THỬ ✨", comment: "Localized string for must try")
            case .program: return NSLocalizedString("SỰ KIỆN ✨", comment: "Localized string for program")
            }
        }
    }

    enum DrinkType: String, CaseIterable, Codable, Comparable {
        case latte = "LATTE"
        case fruitTea = "TRÀ TRÁI CÂY"
        case milkTea = "TRÀ SỮA"
        case coffee = "CÀ PHÊ"
        case events = "SỰ KIỆN"
        
        // Define an order for the drink types
        static func < (lhs: DrinkType, rhs: DrinkType) -> Bool {
            let order: [DrinkType] = [.latte, .fruitTea, .milkTea, .coffee, .events]
            return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
        }
        
        // Fallback case for invalid drink types
        static func from(rawValue: String) -> DrinkType {
            return DrinkType(rawValue: rawValue) ?? .events
        }

        // Computed property for localization
        func localized(locale: Locale) -> String {
            switch self {
            case .latte: return NSLocalizedString("LATTE", comment: "Localized string for latte")
            case .fruitTea: return NSLocalizedString("TRÀ TRÁI CÂY", comment: "Localized string for fruit tea")
            case .milkTea: return NSLocalizedString("TRÀ SỮA", comment: "Localized string for milk tea")
            case .coffee: return NSLocalizedString("CÀ PHÊ", comment: "Localized string for coffee")
            case .events: return NSLocalizedString("SỰ KIỆN", comment: "Localized string for events")
            }
        }
    }
}

