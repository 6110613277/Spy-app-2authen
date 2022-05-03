//
//  MessageRowView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI
import Kingfisher

struct MessageRowView: View {
    let message: Message
    
    var ownAccout: Bool {
        message.senderID == AuthViewModel.shared.userSession?.uid
    }
    
    var body: some View {
        HStack(spacing: 15) {
            if !ownAccout {
                if let imageURL = message.ownerImageURL {
                    KFImage(URL(string: imageURL))
                        .resizeTo(width: 50, height: 50)
                        .clipped()
                        .clipShape(Circle())
                }
            }
            
            if ownAccout {
                Spacer(minLength: 0)
            }
            
            VStack(alignment: ownAccout ? .trailing : .leading, spacing: 5) {
                Text(message.message)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(MessageBubble(ownAccout: ownAccout))
                
                
                Text(message.timestampText())
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(ownAccout ? .trailing : .leading)
            }
            
            if !ownAccout {
                Spacer(minLength: 0)
            }
            
            if ownAccout {
                if let imageURL = message.ownerImageURL {
                    KFImage(URL(string: imageURL))
                        .resizeTo(width: 50, height: 50)
                        .clipped()
                        .clipShape(Circle())
                }
            }

        }
        .padding()
    }
}


