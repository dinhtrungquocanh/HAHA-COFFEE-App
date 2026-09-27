//
//  InputView.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 16/12/2024.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
            } else {
                TextField(placeholder, text: $text)
                    .disableAutocorrection(true)
                    .padding(.top, 20)
            }

            Divider()
        }
    }
}

struct InputViewPreviews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email", placeholder: "name@example.com")
    }
}
