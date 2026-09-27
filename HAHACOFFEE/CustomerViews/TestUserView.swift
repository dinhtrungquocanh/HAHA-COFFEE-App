//
//  TestUserView.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 20/11/2024.
//

import SwiftUI
struct TestUserView: View {
    @EnvironmentObject var dataManager : DataManager
    var body: some View {
        NavigationView{
            List(dataManager.users,id:\.id){user in
                Text(user.email)
            }
            .navigationTitle("Adminstrators Info")
            .navigationBarItems(trailing:Button(action:{},label:{
                Image(systemName:"cloud")
            }))
        }
    }
}

struct TestUserView_Previews: PreviewProvider {
    static var previews: some View {
        TestUserView()
            .environmentObject(DataManager())
    }
}

