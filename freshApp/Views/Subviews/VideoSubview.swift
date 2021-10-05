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
        PostView(post: post)
    }
}

struct VideoSubview_Previews: PreviewProvider {
    static var previews: some View {
        VideoSubview(post: Post(id: "id", image: nil, title: "title", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: []))
            .environmentObject(FirebaseModel())
    }
}
