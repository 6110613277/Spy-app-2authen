//
//  FeedView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
    
    
    var body: some View {
        ScrollView {
            LazyVStack{
                ForEach(viewModel.posts ){ post in
                    FeedCell(viewModel: FeedCellViewModel(post: post))
                }
            }
        }
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
