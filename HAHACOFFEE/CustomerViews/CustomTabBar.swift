//
//  CustomTabBar.swift
//  HAHApro
//
//  Created by Phương An on 25/09/2024.
//

import Foundation
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab : String
    //Animation for sliding effect
    @Namespace var animation
    var body: some View {
            HStack(spacing : 0){
                // Tab bar button
                TabBarButton(animation: animation , image: "home",selectedTab: $selectedTab)
                TabBarButton(animation: animation , image: "menu",selectedTab: $selectedTab)
                TabBarButton(animation: animation , image: "qrcode",selectedTab: $selectedTab)
                TabBarButton(animation: animation , image: "cart", selectedTab: $selectedTab)
            }
            .padding(.top)
            .background(.white)
        }
}

struct CustomTabBar_Previews : PreviewProvider{
    static var previews: some View{
        MainView_Viet()
    }
}
struct TabBarButton : View{
    var animation : Namespace.ID
    var image : String
    @Binding var selectedTab : String
    var body: some View {
        Button(action: {
            withAnimation(.spring()){
                selectedTab = image
            }
        }, label: {
            VStack(spacing : 8){
                Image(image)
                    .resizable()
                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fit)
                    .frame(width:28,height : 28)
                    .foregroundColor(selectedTab == image ? .color2 : .gray.opacity(0.4))
                if selectedTab == image{
                    Circle()
                        .fill(.pink)
                    //Sliding effect
                        .matchedGeometryEffect(id: "TAB", in: animation)
                        .frame(width : 8 , height : 8)
                }
            }
            .frame(maxWidth : .infinity)
        })
    }
}
/*
struct TabBarButton_Cart: View {
    var animation: Namespace.ID
    var image: String
    @Binding var selectedTab: String

    var body: some View {
        NavigationLink(destination: CartView()) {
            VStack(spacing: 8) {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(selectedTab == image ? .color2 : .gray.opacity(0.4))
                if selectedTab == image{
                    Circle()
                        .fill(.pink)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedTab = image
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Removes NavigationLink's default style
    }
}
*/
