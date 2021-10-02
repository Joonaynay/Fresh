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
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { pres.wrappedValue.dismiss() }, label: {
                HStack {
                Image(systemName: "chevron.left")
                    .font(Font.headline.weight(.bold))
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
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding()
            HStack {
                NavigationLink(
                    destination: ProfileView(user: post.user),
                    label: {
                        VStack {
                            HStack {
                                if post.user.profileImage != nil {
                                    Image(uiImage: post.user.profileImage!)
                                        .resizable()
                                        .frame(width: 30, height: 30)
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
                    fb.followUser(currentUser: fb.currentUser, followUser: post.user)
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
            Text("This is my comments.")
                .padding()
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(post: Post(id: "ds", image: UIImage(systemName: "person")!, title: "ds", subjects: [], date: "ds", user: User(id: "sa", username: "sd", name: "asdf", profileImage: nil, following: [], followers: [], numFollowers: 0, numFollowing: 0, posts: nil)))
    }
}
