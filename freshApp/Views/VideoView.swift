//
//  VideoView.swift
//  freshApp
//
//  Created by Wendy Buhler on 9/25/21.
//

import SwiftUI

struct VideoView: View {
    
    let post: Post
    @State private var animate: Bool = false
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.presentationMode) private var pres
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Button(action: { pres.wrappedValue.dismiss() }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(Font.headline.weight(.bold))
                            .padding()
                    }
                })
                .padding()
                if post.image == nil {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                } else {
                    Image(uiImage: post.image!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                }
                Text(post.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 60)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 8)
                    .padding(.leading)
                HStack {
                    Spacer()
                    Image(systemName: "hand.thumbsup")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(post.likes.count)")
                        .font(Font.headline.weight(.bold))
                }
                .padding(.trailing)
                HStack {
                    NavigationLink(
                        destination: ProfileView(user: post.user),
                        label: {
                            VStack {
                                HStack {
                                    if post.user.profileImage != nil {
                                        Image(uiImage: post.user.profileImage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 30, height: 30)
                                            .clipped()
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                    Text(post.user.username)
                                }
                                Text("Followers: \(post.user.followers.count)")
                                    .foregroundColor(Color.theme.secondaryText)
                            }
                            
                        })
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            animate.toggle()
                        }
                        fb.followUser(followUser: post.user)
                    }, label: {
                        Text(animate ? "Unfollow" : "Follow")
                            .frame(width: animate ? UIScreen.main.bounds.width / 2.5 : UIScreen.main.bounds.width / 3.0, height: 45)
                            .background(Color.theme.pinkColor)
                    })
                }
                .padding(.horizontal)
                .padding(.bottom)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(Color.theme.secondaryText)
                ScrollView {
                Text("This is my comments.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 50)
                }
                .padding(.horizontal)
            }
            .foregroundColor(Color.theme.accent)
            .navigationBarHidden(true)
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(post: Post(id: "ds", image: UIImage(systemName: "person")!, title: "This is a cool title sick man cool titlehaha.", subjects: [], date: "ds", user: User(id: "sa", username: "sd", name: "asdf", profileImage: nil, following: [], followers: [], posts: nil), likes: ["sup", "yo"]))
    }
}
