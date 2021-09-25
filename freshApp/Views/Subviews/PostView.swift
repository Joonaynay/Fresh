//
//  PostView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/24/21.
//

import SwiftUI
import FirebaseAuth

struct PostView: View {
    
    @EnvironmentObject private var fb: FirebaseModel
    var post: Posts
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(uiImage: post.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            Text(post.caption)
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding(.top, 10)
                .padding(.horizontal, 10)
            HStack {
                Image(uiImage: post.profileImage)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .scaledToFill()
                Text(post.username)
                    .multilineTextAlignment(.leading)
                    .font(.callout)
            }.padding(10)
            Text(post.date)
                .font(.caption2)
                .padding(10)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.secondaryText)
        }
    }
}

