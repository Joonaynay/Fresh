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
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                TitleBarView(title: "Following")
                ScrollView(showsIndicators: false) {
                    Button(action: { fb.loadPosts() }, label: {
                        Text("Load")
                    })
                    VStack {
                        ForEach(fb.posts) { post in
                            if fb.currentUser.following!.contains(post.user.id) {
                                PostView(post: post)
                            }
                        }
                    }
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

struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView()
            .environmentObject(FirebaseModel())
    }
}
