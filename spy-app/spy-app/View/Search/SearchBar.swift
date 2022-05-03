//
//  SearchBar.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text : String
    @Binding var isEditing : Bool
    var body: some View {
        HStack {
            TextField("Search...",text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0,maxWidth: .infinity, alignment: .leading)
                    }
            )
            Button(action: {
                isEditing = false
                text = ""
                UIApplication.shared.endEditing()
                
            }){
                Text("Cancel")
                    .foregroundColor(.black)
            }
            .padding(.trailing,8)
            .transition(.move(edge: .trailing))
            .animation(.default)
        }
        .onTapGesture {
            isEditing = true
        }
    }
}

