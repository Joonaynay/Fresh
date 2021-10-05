//
//  VideoSubview.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI

struct VideoSubview: View {
    
    let post: Post
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        VStack {
            Image(uiImage: post.image!)
                .resizable()
                .frame(width: UIScreen.main.bounds.width / 1.05, height: UIScreen.main.bounds.width / 1.05)
            Text(post.title)
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(post.user.username)
            }
            
        }
    }
}

struct VideoSubview_Previews: PreviewProvider {
    static var previews: some View {
        VideoSubview(post: Post(id: "id", image: nil, title: "title", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: []))
            .environmentObject(FirebaseModel())
    }
}
