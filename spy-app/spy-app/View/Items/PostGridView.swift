//
//  PostGridView.swift
//  spy-app
//
//  Created by Siriluk Rachaniyom on 1/5/2565 BE.
//


import SwiftUI
import Kingfisher

struct PostGridView: View {
    
    @ObservedObject var viewModel : GridViewModel
    
    let items = [GridItem(),GridItem(),GridItem()]
    
    init(config: PostGridConfig) {
        viewModel = GridViewModel(config: config)
    }
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: items, spacing: 2) {
                ForEach(viewModel.posts){ post in
                    KFImage(URL(string: post.imageURL))
                        .resizeTo(width: proxy.size.width / 3, height: proxy.size.width / 3)
                        .clipped()
                }
            }
        }
    }
}