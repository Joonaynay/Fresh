//
//  VideoSubview.swift
//  freshApp
//
//  Created by Wendy Buhler on 10/4/21.
//

import SwiftUI
import FirebaseFirestore
import AVKit

struct VideoSubview: View {
    
    @State var post: Post
    
    @EnvironmentObject private var fb: FirebaseModel
    
    private let ProfileViewTag = "ProfileView"
    @State private var selection: String? = ""
    @State private var overlayImage: Bool = true
    @State private var follow: Bool = false
    
    @State var player: AVPlayer?
    
    @State private var liked: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                
                if overlayImage {
                    
                    Button(action: { overlayImage = false; self.player = AVPlayer(url: post.movie); player!.play() }, label: {
                        ZStack {
                            Image(uiImage: post.image)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    })
                    
                } else {
                    CustomVideoPlayer(player: $player)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9/16)
                        .onDisappear() {
                            player!.pause()
                        }
                    
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
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            fb.likePost(currentPost: post)
                        }, label: {
                            if liked {
                                Image(systemName: "hand.thumbsup.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.theme.blueColor)
                            } else {
                                
                                Image(systemName: "hand.thumbsup")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            
                        })
                        .onAppear() {
                            let db = Firestore.firestore()
                            db.collection("posts").document(post.id).addSnapshotListener { doc, error in
                                if error == nil {
                                    self.post.likes = doc?.get("likes") as! [String]
                                    if self.post.likes.contains(fb.currentUser.id) {
                                        self.liked = true
                                    } else {
                                        self.liked = false
                                    }
                                }
                            }
                            if fb.currentUser.following.contains(post.user.id) {
                                follow = true
                            }
                            
                        }
                        
                        Text("\(post.likes.count)")
                            .font(Font.headline.weight(.bold))
                    }
                    if post.user.id != fb.currentUser.id {
                        Button(action: {
                            fb.followUser(followUser: post.user)
                            follow.toggle()
                        }, label: {
                            Text(follow ? "Unfollow" : "Follow")
                                .frame(width: follow ? (UIScreen.main.bounds.width / 3) : (UIScreen.main.bounds.width / 4), height: 40)
                                .foregroundColor(Color.theme.blueTextColor)
                                .background(Color.theme.blueColor)
                        })
                    }
                }
            }
            
            .padding(.horizontal)
            
            Text(post.date)
                .font(.caption2)
                .padding(10)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(Color.theme.lineColor)
        }
    }
}

struct VideoSubview_Previews: PreviewProvider {
    static var previews: some View {
        VideoSubview(post: Post(id: "id", image: UIImage(contentsOfFile: "Logo.png")!, title: "title", subjects: [], date: "date", user: User(id: "id", username: "username", name: "name", profileImage: nil, following: [], followers: [], posts: nil), likes: [], comments: [], movie: URL(fileURLWithPath: "")), player: AVPlayer(url: URL(fileURLWithPath: "")))
            .environmentObject(FirebaseModel())
    }
}
