//
//  LanguageSetting.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 03/12/2024.
//

import SwiftUI

class LanguageSetting: ObservableObject {
    @Published var locale: Locale = Locale(identifier: "en")
}
