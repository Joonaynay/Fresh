//
//  FollowingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct FollowingView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var offSetY: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TitleBarView(title: "Following")
                if fb.loading {
                    ProgressView()
                        .padding()
                }
                ScrollView(showsIndicators: false) {
                    
                    ZStack {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.clear)
                        VStack {
                            ForEach(fb.posts) { post in
                                if fb.currentUser.following.contains(post.user.id) {
                                    PostView(post: post, user: post.user)
                                }
                            }
                        }
                    }
                }
                .offset(y: offSetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            if value.translation.height > 0 {
                                offSetY = value.translation.height
                            }

                            if offSetY >= 15 && fb.loading == false {
                                fb.loadFollowingPosts()
                                offSetY = 0
                            }
                            offSetY = 0
                        })
                        .onEnded({ value in
                            offSetY = 0
                        })
                )
            }
        }
        .background(
            Image(colorScheme == .dark ? "darkmode" : "lightmode")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
        .navigationBarHidden(true)
    }
}

struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView()
            .environmentObject(FirebaseModel())
    }
}
