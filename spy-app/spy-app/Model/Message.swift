//
//  Message.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//


import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Message: Decodable, Identifiable, Hashable {
    @DocumentID var id: String?
    let senderID: String
    let receiverID: String
    var message: String
    let timestamp: Timestamp?
    let ownerImageURL: String?
    
    func timestampText() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp?.dateValue() ?? Date(), to: Date()) ?? ""
    }
}
