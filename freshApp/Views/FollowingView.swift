//
//  FollowingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct FollowingView: View {
    
    @EnvironmentObject var fb: FirebaseModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                TitleBarView(title: "Following")
                ScrollView(showsIndicators: false) {
                    Button(action: { fb.loadPosts() }, label: {
                        Text("Load")
                    })
                    VStack {
                        ForEach(fb.posts) { post in
                            
                            PostView(post: post)
                            
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView()
            .environmentObject(FirebaseModel())
    }
}
