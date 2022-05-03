//
//  UploadPostViewModel.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI
import Firebase

class UploadPostViewModel: ObservableObject {
    func uploadPost(image: UIImage, caption: String){
        guard let user = AuthViewModel.shared.currentUser else {return}
        
        ImageUploader.uploadImage(image: image, type: .post){ imageURL in
            guard let uid = user.id else {return}
            
            let data = [
                "caption" : caption,
                "timestamp" : Timestamp(date: Date()),
                "likes": 0,
                "imageURL": imageURL,
                "ownerUID": uid,
                "ownerUsername": user.username
            ] as [String: Any]
            Firestore.firestore().collection("posts").addDocument(data: data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/post_image/\(filename)")
        
        ref.putData(imageData, metadata: nil){ (_, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            ref.downloadURL{ (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let imageURL = url?.absoluteString else {return}
                
               
            }
        }
        
    }
}
