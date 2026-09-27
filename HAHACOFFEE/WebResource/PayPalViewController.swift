//
//  PayPalViewController.swift
//  HAHACOFFEE
//
//  Created by Đinh Trung Quốc Anh on 14/1/25.
//

import WebKit
import SwiftUI

struct LocalWebView: UIViewRepresentable {
    let filePath: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: filePath) {
            uiView.load(URLRequest(url: url))
        } else {
            print("Invalid file path: \(filePath)")
        }
    }
}
