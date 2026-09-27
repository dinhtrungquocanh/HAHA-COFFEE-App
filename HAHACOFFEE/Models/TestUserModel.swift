//
//  TestUserViewModel.swift
//  HAHACOFFEE
//
//  Created by SEIU iMac 4 on 26/11/2024.
//
import Foundation
import FirebaseFirestore
import Firebase
struct User_Test: Codable, Identifiable {
    var id: String
    var email: String
    var name: String
    var password: String
    var phonenumber: String
}
class DataManager : ObservableObject{
    @Published var users : [User_Test] = []
    init(){
        fetchUsers()
    }
    func fetchUsers(){
        users.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("User")
        ref.getDocuments{snapshot,error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot{
                for document in snapshot.documents{
                    let data = document.data()
                    let id = data["id"]as? String ?? "Error"
                    let email = data["email"]as? String ?? "Error"
                    let name = data["name"]as? String ?? "Error"
                    let password = data["password"]as? String ?? "Error"
                    let phonenumber = data["phonenumber"]as? String ?? "Error"
                    let user = User_Test(id: id, email: email, name: name, password: password, phonenumber: phonenumber)
                    self.users.append(user)
                }
            }
        }
    }
}
