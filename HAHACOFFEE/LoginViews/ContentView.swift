//
//  ContentView.swift
//  newHAHACOFFEE
//
//  Created by Phương An on 23/09/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageSettings: LanguageSetting

    var body: some View {
        NavigationView {
            VStack {
                Image("LOGO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center)
                    .padding(.top)

                Text("Choose your language")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .bold()
                    .padding(.top)

                VStack(spacing: 20) {
                    // English button
                    NavigationLink(destination: MainView_Viet()) {
                        Text("English 🇬🇧")
                            .font(.system(size: 15))
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        languageSettings.locale = Locale(identifier: "en")
                    })

                    // Vietnamese button
                    NavigationLink(destination: MainView_Viet()) {
                        Text("Tiếng Việt 🇻🇳")
                            .font(.system(size: 15))
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        languageSettings.locale = Locale(identifier: "vi")
                    })
                    
                    /*
                    // Button tạm thời để chọn row
                    NavigationLink(destination: StaffView()) {
                        Text("For Staff")
                            .font(.system(size: 15))
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                     */
                    
                    
                }
                .padding(.top, 30)

                Spacer()

                Text("Copyright © HAHA Coffee All Rights Reserved.")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                    .padding(.bottom, 20)
            }
            .navigationBarHidden(true) // Hide the navigation bar if not needed
            .background(Color.white.ignoresSafeArea()) // Set the background color
        }
    }
}

struct EnglishView: View {
    var body: some View {
        Text("Sorry! We are updating the English view.")
            .foregroundColor(.color2) // Ensure color is defined
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .environmentObject(LanguageSetting())// Correctly use .environmentObject
    }
}


extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

