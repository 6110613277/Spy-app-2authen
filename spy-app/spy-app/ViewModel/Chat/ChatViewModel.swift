//
//  ChatViewModel.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 2/5/2565 BE.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift

class ChatViewModel: ObservableObject {
    @Published var user = [User]()
    
    init() {
        guard let current = AuthViewModel.shared.userSession?.uid else { return }
        GettAllUser()
    }
    
    func GettAllUser(){
        guard let current = AuthViewModel.shared.userSession?.uid else { return }
        Firestore.firestore().collection("users").whereField("uid", isNotEqualTo: current).getDocuments {(snap,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snap?.documents else { return }
            
            self.user = documents.compactMap {
                try? $0.data(as: User.self)
            }
        }
    }
}
