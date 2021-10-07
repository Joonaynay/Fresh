//
//  VideoView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/25/21.
//

import SwiftUI


struct VideoView: View {
    
    @State var post: Post

    @State private var showComments: Bool = false
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Button(action: { pres.wrappedValue.dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .padding()
                })
                VideoSubview(post: post)
                Button(action: {
                    fb.loadComments(currentPost: post) { comments in
                        if let comments = comments {
                            post.comments = comments
                        }
                        showComments = true
                    }
                    
                    
                }, label: {
                    Text("Comments")
                })
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showComments, content: {
            CommentsView(post: post)
        })
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(post: Post(id: "id", image: UIImage(contentsOfFile: "Logo.png")!, title: "title", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: [], movie: URL(fileURLWithPath: "")))
            .environmentObject(FirebaseModel())
    }
}

