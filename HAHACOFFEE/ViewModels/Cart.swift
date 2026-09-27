import SwiftUI

class CartManager: ObservableObject {
    @Published var items: [Features] = []
    @Published var totalAmount: Double = 0.0
    
    
    // Method to add a drink to the cart
    func addToCart(drink: Features) {
        items.append(drink)
        calculateTotal()
    }
    
    // Method to calculate the total amount
    private func calculateTotal() {
        totalAmount = items.reduce(0) { $0 + (Double($1.price) ?? 0.0) }
    }
}


