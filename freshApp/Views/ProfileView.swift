//
//  ProfileView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/22/21.
//

import SwiftUI

struct ProfileView: View {
    
    let post: Post?
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    let currentUser: User
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Button (action: { pres.wrappedValue.dismiss() }, label: {
                    HStack {
                    Image(systemName: "chevron.left")
                        .font(Font.headline.weight(.bold))
                        Text("Back")
                    }
                    .padding()
                })
                    if post == nil {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                            VStack {
                                Text(currentUser.username)
                                VStack {
                                    Text("Followers")
                                    Text("\(currentUser.followers.count)")
                                }
                                .padding()
                                VStack {
                                    Text("Following")
                                    Text("\(currentUser.following.count)")
                                }
                            }
                            .padding()
                        }
                    } else {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                            Text(post!.user.username)
                            Text("Followers \(post!.user.followers.count)")
                            Text("Following \(post!.user.following.count)")
                        }
                    }
                
                ScrollView {
                    Spacer()
                    ForEach(fb.posts) { post in
                        HStack {
                            Image(uiImage: post.image)
                                .resizable()
                                .frame(width: 120, height: 120)
                            
                            Text(post.title)
                                .font(.body)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
            }
            
        }
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(post: nil, currentUser: User(id: "Joonaynay", username: "ds", name: "ds", profileImage: nil, following: [], followers: [], posts: []))
            .preferredColorScheme(.dark)
            .environmentObject(FirebaseModel())
    }
}
