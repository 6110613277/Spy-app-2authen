//
//  EditProfileViewModel.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import Foundation
import Firebase

class EditProfileViewModel: ObservableObject {
    var user: User
    @Published var uploadComplete = false
    init(user: User){
        self.user = user
    }
    
    func saveBio(bio: String){
        guard let userID = user.id else { return }
        
        Firestore.firestore().collection("users").document(userID).updateData(["bio":bio]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.user.bio = bio
            self.uploadComplete = true
        }
    }
}
