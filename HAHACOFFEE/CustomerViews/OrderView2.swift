import SwiftUI

struct CoffeeOrderView2: View {
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var cartManager: CartStore
    @EnvironmentObject var languageSettings: LanguageSetting
    
    var drink: Features
    var cartItem: CartItem?
    
    @State private var selectedSize: String = "S"
    @State private var selectedIce: String = "100%"
    @State private var selectedSugar: String = "100%"
    @State private var quantity: Int = 1
    @State private var animateCart: Bool = false
    
    init(drink: Features, cartItem: CartItem? = nil) {
        self.drink = drink
        self.cartItem = cartItem
        _selectedSize = State(initialValue: cartItem?.size ?? "S")
        _selectedIce = State(initialValue: cartItem?.ice ?? "100%")
        _selectedSugar = State(initialValue: cartItem?.sugar ?? "100%")
        _quantity = State(initialValue: cartItem?.quantity ?? 1)
    }
    
    
    var body: some View {
        
        //ProgressView()
        
        ScrollView {
            
            ZStack(alignment: .topTrailing){
                /*
                NavigationLink(destination: CartView()) {
                    Button(action: {
                        animateCartBadge() // Trigger animation
                        //cartManager.saveOrder()
                    }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .background(
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 60, height: 60)
                            )
                            .foregroundColor(.white)
                        //.shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                            .scaleEffect(animateCart ? 1.2 : 1.0) // Animate scale
                    }
                    .padding(.trailing, 20)
                    .overlay{
                        Text("\(cartManager.numberOfItems)")
                            .foregroundColor(.white)
                            .padding(8)
                            .font(.caption2)
                            .background(.red)
                            .clipShape(Circle())
                            .offset(x: 3, y: -10)
                    }
                }
                 */

                
                VStack{
                    drink.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Coffee Name and Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text(languageSettings.locale.identifier == "en" ? drink.drinkName_en : drink.drinkName)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(languageSettings.locale.identifier == "en" ? drink.description_en : drink.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(languageSettings.locale.identifier == "en" ? drink.ingredients_en : drink.ingredients)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Size Selection
                        sectionView(title: LocalizedStringKey("Kích cỡ")) {
                            alignedButtons(
                                buttons: ["S", "M", "L"],
                                labels: ["S", "M", "L"],
                                selectedValue: $selectedSize
                            )
                        }
                        
                        // Ice Level Selection
                        sectionView(title: LocalizedStringKey("Chọn mức đá")) {
                            alignedButtons(
                                buttons: ["100%", "50%", "0%"],
                                labels: ["100%", "50%", "0%"],
                                selectedValue: $selectedIce
                            )
                        }
                        
                        // Sugar Level Selection
                        sectionView(title: LocalizedStringKey("Chọn mức đường")) {
                            alignedButtons(
                                buttons: ["100%", "50%", "0%"],
                                labels: ["100%", "50%", "0%"],
                                selectedValue: $selectedSugar
                            )
                        }
                        
                        // Quantity Selector
                        HStack {
                            Stepper("Số lượng: \(quantity)", value: $quantity, in: 1...10)
                        }
                        
                        // Price & Add to Cart
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("\(quantity) Sản phẩm")
                                Spacer()
                                if let price = Int(drink.price.components(separatedBy: ".").joined()) {
                                    Text("\(Int(drink.price.components(separatedBy: ".").joined())! * quantity) VNĐ")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                } else {
                                    Text("N/A")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        
                        Button(action: {
                            animateCartBadge() // Trigger animation
                            addToCart()
                            
                            print("Thanh toán thành công....Xin chờ giây lát")
                        }) {
                            Text("Thêm vào giỏ hàng")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal)
                }
            }
        }
            .navigationBarTitle(Text(languageSettings.locale.identifier == "en" ? drink.drinkName_en : drink.drinkName), displayMode: .inline)
            .navigationBarItems(trailing:
                                    NavigationLink(destination: CartView()) {
                                        Button(action: {
                                            animateCartBadge() // Trigger animation
                                            //cartManager.saveOrder()
                                        }) {
                                            Image(systemName: "cart.badge.plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35, height: 35)
                                            /*
                                                .background(
                                                    Circle()
                                                        .fill(.blue)
                                                        .frame(width: 60, height: 60)
                                                )
                                             */
                                                .foregroundColor(.black)
                                            //.shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                                                .scaleEffect(animateCart ? 1.2 : 1.0) // Animate scale
                                        }
                                        .padding(.trailing, 5)
                                        .overlay{
                                            Text("\(cartManager.numberOfItems)")
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .font(.caption2)
                                                .background(.red)
                                                .clipShape(Circle())
                                                .offset(x: 6, y: -10)
                                        }
                                    }
                                    )
        }

    // Helper for creating bordered sections with only top and bottom lines
    private func sectionView<Content: View>(title: LocalizedStringKey, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(.vertical)
        .overlay(
            VStack {
                Divider()
                Spacer()
                Divider()
            }
        )
    }

    // Helper for aligned buttons
    private func alignedButtons(
        buttons: [String],
        labels: [String]? = nil,
        selectedValue: Binding<String>
    ) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: buttons.count)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<buttons.count, id: \.self) { index in
                Button(action: {
                    selectedValue.wrappedValue = buttons[index]
                }) {
                    VStack {
                        Image(systemName: selectedValue.wrappedValue == buttons[index] ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedValue.wrappedValue == buttons[index] ? .color2 : .gray)
                        
                        Text(labels?[index] ?? buttons[index])
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity) // Ensure all buttons have equal width
                    .padding()
                    .background(selectedValue.wrappedValue == buttons[index] ? Color.color2.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity) // Stretch the grid across available width
    }
    
    func addToCart() {
        let total = calculateTotalPrice()
        let cartItem = CartItem(
            id: UUID().uuidString,
            drinkId: drink.id,
            drinkName: drink.drinkName,
            drinkName_en: drink.drinkName_en,
            size: selectedSize,
            ice: selectedIce,
            sugar: selectedSugar,
            quantity: quantity,
            totalPrice: total
        )
        cartManager.addCartItem(cartItem)
    }

    func calculateTotalPrice() -> Int {
        if let price = Int(drink.price.components(separatedBy: ".").joined()) {
            return price * quantity
        }
        return 0
    }

    private func animateCartBadge() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateCart = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.3)) {
                animateCart = false
            }
        }
    }
}




/*
#Preview {
    if let firstDrink = ModelData().drinks.first {
        CoffeeOrderView2(drink: firstDrink)
            .environmentObject(CartManager())
            .environmentObject(ModelData())
    } else {
        Text("No drinks available")
    }
}
 */

/*
let mockData: [String: Any] = [
    "id": "1",
    "drinkName": "Mock Coffee",
    "price": "30000",
    "description": "A mock coffee for testing purposes.",
    "ingredients": "Coffee, Water",
    "category": "bestsellers",
    "imageName": "cup.and.saucer"
]

#Preview {
    let mockModelData = ModelData()
    let mockDrink = Features(data: mockData)
    mockModelData.drinks = [mockDrink]
    CoffeeOrderView2(drink: mockModelData.drinks.first!)
        .environmentObject(mockModelData)
        .environmentObject(CartManager())
}
 */

let mockData: [String: Any] = [
    "id": "1",
    "drinkName": "Mock Coffee",
    "price": "30000",
    "description": "A mock coffee for testing purposes.",
    "ingredients": "Coffee, Water",
    "category": "bestsellers",
    "imageName": "cup.and.saucer"
]

#Preview {
    let mockModelData = ModelData()
    
    // Safely unwrap the mock drink created using the initializer
    if let mockDrink = Features(data: mockData) {
        // Add the mock drink to the drinks array
        mockModelData.drinks = [mockDrink]
        
        // Return the view using the first drink from the mock data
        return CoffeeOrderView2(drink: mockModelData.drinks.first!)
            .environmentObject(mockModelData)
            .environmentObject(CartStore())
    } else {
        // Fallback in case initialization fails
        return Text("Failed to create mock data")
    }
}

