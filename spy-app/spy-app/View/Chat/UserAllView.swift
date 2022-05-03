//
//  UserAllView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 2/5/2565 BE.
//

import SwiftUI

struct AllUserView: View {
    @ObservedObject var viewModel = ChatViewModel()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    ForEach(viewModel.user ){ user in
                        NavigationLink(destination:MessageChatView(user: user)){
                            Text(user.fullname)
                                .font(.system(size: 20))
                        }
                    }
                }
            }
            .navigationBarItems(trailing: logOutButton)
            .accentColor(.black)
        }
    }
    var logOutButton : some View {
        Button {
            AuthViewModel.shared.signOut()
        } label: {
            Text("Log Out")
                .foregroundColor(.black)
        }
    }}

struct AllUserView_Previews: PreviewProvider {
    static var previews: some View {
        AllUserView()
    }
}
