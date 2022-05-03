//
//  EditProfileView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//


import SwiftUI

struct EditProfileView: View {
    @State var bio: String
    @Binding var user: User
    @Environment(\.presentationMode) var mode
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(user: Binding<User>){
        _user = user
        viewModel = EditProfileViewModel(user: _user.wrappedValue)
        _bio = State(initialValue: _user.bio.wrappedValue ?? "")
    }
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    mode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.saveBio(bio: bio)
                }) {
                    Text("Done")
                }
            }
            .padding()
            
            TextArea("Add your bio...", text: $bio)
                .frame(width: 370, height: 200)
                .padding()
            
            Spacer()
        }
        .onReceive(viewModel.$uploadComplete) { complete in
            if complete {
                mode.wrappedValue.dismiss()
                user.bio = viewModel.user.bio
            }
        }
    }
}
