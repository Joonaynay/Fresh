//
//  TrendingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct TrendingView: View {
    
    
    @EnvironmentObject private var fb: FirebaseModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var offSetY: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {                
                TitleBarView(title: "Trending")
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
                                PostView(post: post, user: post.user)
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
                                fb.loadPosts()
                                offSetY = 0
                            }
                            offSetY = 0
                        })
                        .onEnded({ value in
                            offSetY = 0
                        })
                )
            }
            .onAppear() {
                if fb.posts.isEmpty {
                    fb.loadPosts()
                    fb.loadFollowingPosts()
                }
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

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
            .environmentObject(FirebaseModel())
    }
}
