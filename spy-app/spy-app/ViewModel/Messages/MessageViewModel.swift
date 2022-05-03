//
//  MessageViewModel.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//


import Foundation
import Firebase
import CryptoKit

class MessageViewModel: ObservableObject {
    let user: User
    let cryptoclass = CryptoKitClass()
    
    @Published var messages = [Message]()
    init(user: User){
        self.user = user
        start()
    }
    
    func start()  {
        
        guard let sender = AuthViewModel.shared.currentUser else { return }
        guard let senderID = AuthViewModel.shared.userSession?.uid else { return }
        guard let receiverID = user.id else { return }
        
        guard let c1 = try? cryptoclass.convertStringToPrivateKey(user.privateKey) else { return }
        guard let c2 = try? cryptoclass.convertStringToPublicKey(sender.publicKey) else { return }
        let sysmetric = cryptoclass.shareSymetric(c1, and: c2)
        
        
        Firestore.firestore().collection("messages").document(senderID).collection("user-messages").document(receiverID).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { [self] snap, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let documentChanges = snap?.documentChanges.filter({$0.type == .added}) else {
                return
            }
            self.messages.append(contentsOf: documentChanges.compactMap{try? $0.document.data(as:Message.self)
            })
            for i in self.messages.indices {
                let mess = self.cryptoclass.deCrypt(self.messages[i].message, and: sysmetric)
                if (mess == "Could not decode" || i == self.messages.endIndex-1) {
                    break
                } else {
                    self.messages[i].message = mess
                }
            }
            if (self.messages.endIndex != 0) {
                self.messages[self.messages.endIndex-1].message = self.cryptoclass.deCrypt(self.messages[self.messages.endIndex-1].message, and: sysmetric)
            }

        }
    }
    func fetchMessage() {
        
        guard let sender = AuthViewModel.shared.currentUser else { return }
        guard let senderID = AuthViewModel.shared.userSession?.uid else { return }
        guard let receiverID = user.id else { return }
        
        guard let c1 = try? cryptoclass.convertStringToPrivateKey(user.privateKey) else { return }
        guard let c2 = try? cryptoclass.convertStringToPublicKey(sender.publicKey) else { return }
        let sysmetric = cryptoclass.shareSymetric(c1, and: c2)
        
        
        Firestore.firestore().collection("messages").document(senderID).collection("user-messages").document(receiverID).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { [self] snap, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let documentChanges = snap?.documentChanges.filter({$0.type == .added}) else {
                return
            }
            self.messages.append(contentsOf: documentChanges.compactMap{try? $0.document.data(as:Message.self)
            })


        }
    }
    
    func sendMessage(message: String){
        guard let sender = AuthViewModel.shared.currentUser else { return }
        guard let senderID = sender.id else { return }
        guard let receiverID = user.id else { return }
        
        guard let c1 = try? cryptoclass.convertStringToPrivateKey(sender.privateKey) else { return }
        guard let c2 = try? cryptoclass.convertStringToPublicKey(user.publicKey) else { return }
        let sysmetric = cryptoclass.shareSymetric(c1, and: c2)
        let encrypmsg = cryptoclass.endCryp(message, and: sysmetric)
        
        
        
       // print(String(data: decryp, encoding: .utf8))
        
        let data: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "message": encrypmsg,
            "timestamp": Timestamp(date: Date()),
            "ownerImageURL": sender.profileImageURL as Any
        ]
        
        Firestore.firestore().collection("messages").document(senderID).collection("user-messages").document(receiverID).collection("messages").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            Firestore.firestore().collection("messages").document(receiverID).collection("user-messages").document(senderID).collection("messages").addDocument(data: data) { error in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
}
