//
//  FeatureView.swift
//  HAHApro
//
//  Created by Phương An on 28/09/2024.
//

import SwiftUI

struct FeatureView: View {
    var feature: Features
    var isCompact: Bool = false // Flag to toggle between compact and full views
    @EnvironmentObject var languageSettings: LanguageSetting
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isCompact {
                VStack {
                    feature.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.top, 6)
                    
                    Text(languageSettings.locale.identifier == "en" ? feature.drinkName_en : feature.drinkName)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color("color1")) 
                .cornerRadius(10)
            } else {
                // Full detailed version
                VStack(alignment: .leading, spacing: 10) {
                    feature.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(languageSettings.locale.identifier == "en" ? feature.drinkName_en : feature.drinkName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.color2)
                    
                    HStack {
                        Text("VND:")
                            .font(.footnote)
                            .foregroundColor(.pink)
                        
                        Text(feature.price)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Text(languageSettings.locale.identifier == "en" ? feature.description_en : feature.description)
                        .font(.footnote)
                        .fontWeight(.regular)
                    
                    // Ingredients information
                    (
                        Text("Ingredients: ")
                            .font(.footnote)
                            .foregroundColor(.pink)
                        +
                        Text(languageSettings.locale.identifier == "en" ? feature.ingredients_en : feature.ingredients)
                            .font(.footnote)
                    )
                }
                .padding()
                .background(Color("color1"))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
