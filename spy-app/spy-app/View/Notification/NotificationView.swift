//
//  NotificationView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//


import SwiftUI

struct NotificationView: View {
    @ObservedObject var viewModel = NotificationsViewModel()
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(viewModel.notifications){ notification in
                    NotificationCell(viewModel: NotificationsCellViewModel(notification: notification))
                        .padding(.top)
                }
            }
        }
        
    }
}
