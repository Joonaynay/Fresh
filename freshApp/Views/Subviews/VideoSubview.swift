//
//  VideoSubview.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI
import AVKit

struct VideoSubview: View {
    
    let post: Post
    
    @EnvironmentObject private var fb: FirebaseModel
    
    private let ProfileViewTag = "ProfileView"
    @State private var selection: String? = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                
                if let url = post.movie {
                    CustomVideoPlayer(url: url)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
                }
                
                
                Text(post.title)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
            }
            
            NavigationLink(
                destination: ProfileView(user: post.user),
                tag: ProfileViewTag,
                selection: $selection,
                label: {})
            HStack {
                Spacer()
                
                Image(systemName: "hand.thumbsup")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                Text("\(post.likes.count)")
                    .font(Font.headline.weight(.bold))
            }
            .padding(.horizontal)
            
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
                .foregroundColor(Color.theme.secondaryText)
        }
    }
}

struct VideoSubview_Previews: PreviewProvider {
    static var previews: some View {
        VideoSubview(post: Post(id: "id", image: nil, title: "title", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: []))
            .environmentObject(FirebaseModel())
    }
}
