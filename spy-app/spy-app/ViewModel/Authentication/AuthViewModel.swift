//
//  AuthViewModel.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI
import Firebase
import CryptoKit

class AuthViewModel : ObservableObject {
    @EnvironmentObject var viewModel : MessageViewModel
    @Published var userSession: Firebase.User?
    @Published var currentUser: User?
    var num = 1
    @AppStorage("log_status") var log_status = false
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    
    func signIn(withEmail email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
            if let error = error {
                //print(error.localizedDescription)
                if self.num == 4{
                    
                }
                print("email/password is wrong \(self.num)")
                self.num += 1
                return
            }
            guard let user = result?.user else {return}
            
            self.userSession = user
            self.fetchUser()
            
        }
    }
    
    func signOut() {
        log_status = false
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    func register(withEmail email:String, password:String,username: String,fullname: String){
        let privatKey = Curve25519.KeyAgreement.PrivateKey()
        let publicKey = privatKey.publicKey
        print([UInt8](privatKey.rawRepresentation.base64EncodedString().utf8))
        print(publicKey.rawRepresentation)
        Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {return}
            
            let data = [
                "email": email,
                "username": username,
                "fullname": fullname,
                "uid": user.uid,
                "privateKey": privatKey.rawRepresentation.base64EncodedString(),
                "publicKey": publicKey.rawRepresentation.base64EncodedString()
            
            ]
            
            Firestore.firestore().collection("users").document(user.uid).setData(data){ error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self.userSession = user
                self.fetchUser()
                
            }
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = try? snap?.data(as: User.self) else { return }
            self.currentUser = user
            
        }
    }
}
