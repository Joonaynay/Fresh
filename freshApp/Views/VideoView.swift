//
//  VideoView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/25/21.
//

import SwiftUI

struct VideoView: View {
    
    let post: Post
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
                Button(action: { showComments = true }, label: {
                    Text("comments")
                })
            }
        }
        .sheet(isPresented: $showComments, content: {
            commentsView(post: post)
        })
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(post: Post(id: "id", image: nil, title: "title", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: []))
            .environmentObject(FirebaseModel())
    }
}

struct commentsView: View {
    
    let post: Post
    @State private var text: String = ""
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack {
                HStack {
                    TextField("Comment", text: $text)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.secondaryText)
                        .overlay(
                            Image(systemName: "xmark.circle.fill")
                                .padding()
                                .offset(x: -20)
                                .foregroundColor(Color.theme.accent)
                                .opacity(text.isEmpty ? 0.0 : 1.0)
                                .onTapGesture {
                                    UIApplication.shared.endEditing()
                                    text = ""
                                }
                            ,alignment: .trailing
                        )
                    Button(action: {
                        fb.commentOnPost(currentPost: post, comment: text)
                        pres.wrappedValue.dismiss()
                    }, label: {
                        Text("Post")
                            .padding(.horizontal)
                    })
                }
                .background(Color.theme.secondaryText)
            }
            ForEach(post.comments, id: \.self, content: { comment in
                HStack {
                    if post.user.profileImage == nil {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipped()
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: post.user.profileImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipped()
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(comment)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 50)
                            .multilineTextAlignment(.leading)
                        Text("Username")
                            .font(.callout)
                    }
                    
                    
                }
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(Color.theme.secondaryText)
            })
        }
        .padding()
    }
}
