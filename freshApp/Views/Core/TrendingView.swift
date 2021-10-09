//
//  TrendingView.swift
//  freshApp
//
//  Created by Forrest Buhler on 9/22/21.
//

import SwiftUI

struct TrendingView: View {
    
    
    @EnvironmentObject private var fb: FirebaseModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                TitleBarView(title: "Trending")
                ScrollView(showsIndicators: false) {
                    ForEach(fb.posts) { post in
                        PostView(post: post)
                        
                    }
                }
            }
            .onAppear() {
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
            .environmentObject(FirebaseModel())
    }
}
