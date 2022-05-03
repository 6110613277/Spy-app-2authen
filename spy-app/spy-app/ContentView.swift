//
//  ContentView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var log_status = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State var selectedIndex = 0
    var body: some View {
        Group{
            if viewModel.userSession == nil {
                SigninView()
            } else {
                if let user = viewModel.currentUser {
                    NavigationView{
                        if log_status{
                            AllUserView()
                        }
                        else{
                            Login()
                        }
                                
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
