//
//  ProfileView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI

struct ProfileView: View {
    @State var user: User
    var body: some View {
        ScrollView{
            VStack(spacing:32){
                ProfileHeaderView(ViewModel: ProfileViewModel(user: user))
                    .padding()
                
                if let currentProfileID = user.id {
                    PostGridView(config: .profile(currentProfileID))
                }
                
            }
        }
    }
}

