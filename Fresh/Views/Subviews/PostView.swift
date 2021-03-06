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
    var post: Post
    let user: User
    @State private var selection: String? = ""
    private let VideoViewTag = "VideoViewTag"
    private let ProfileViewTag = "ProfileView"
    
//    init(post: Post) {
//        self.post = post
//        let index = fb.users.firstIndex { userIndex in
//            userIndex.id == post.user.id
//        }
//        if let index = index {
//            self.user = fb.users[index]
//        }
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(
                destination: VideoView(post: post),
                tag: VideoViewTag,
                selection: $selection,
                label: {})
            
            Button(action: { selection = VideoViewTag }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Image(uiImage: post.image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
                        .scaledToFill()
                        .clipped()
                    
                    
                    Text(post.title)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                }
            })
            .buttonStyle(PlainButtonStyle())
            
            NavigationLink(
                destination: ProfileView(user: post.user),
                tag: ProfileViewTag,
                selection: $selection,
                label: {})
            
            Button(action: { selection = ProfileViewTag}, label: {
                HStack {
                    if post.user.profileImage != nil {
                        Image(uiImage: post.user.profileImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipped()
                            .clipShape(Circle())
                            .scaledToFill()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    Text(post.user.username)
                        .multilineTextAlignment(.leading)
                        .font(.callout)
                }.padding(10)
            })
            .buttonStyle(PlainButtonStyle())
            
            Text(post.date)
                .font(.caption2)
                .padding(10)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.lineColor)
        }
        
    }
}

