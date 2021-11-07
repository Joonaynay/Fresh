//
//  CommentView.swift
//  freshApp
//
//  Created by Forrest Buhler on 10/5/21.
//

import SwiftUI

struct CommentsView: View {
    
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
                                .foregroundColor(Color.theme.accentColor)
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
            if let comments = post.comments {
                ForEach(comments) { comment in
                    CommentView(comment: comment)
                }
            }

            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.lineColor)
        }
        .padding()
    }
}


struct CommentView: View {
    
    let comment: Comment
    
    var body: some View {
        HStack {
            if comment.user.profileImage == nil {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipped()
                    .clipShape(Circle())
            } else {
                Image(uiImage: comment.user.profileImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipped()
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(comment.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 50)
                    .multilineTextAlignment(.leading)
                Text(comment.user.username)
                    .font(.callout)
            }
        }
    }
}

